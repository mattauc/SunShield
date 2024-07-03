//
//  WeatherManager.swift
//  SunShield
//
//  Created by Matthew Auciello on 19/6/2024.
//

import Foundation
import Combine
import CoreLocation
import SwiftUI

class WeatherManager: ObservableObject {
    @Published private(set) var weatherData: WeatherResponse
    private let deviceLocationService: DeviceLocationService
    private var geocoder = CLGeocoder()
    @Published private var locationName: String = "Loading..."
    private var isFirstFetch: Bool = true
    
        
    private var coordinates: (lat: Double, lon: Double) = (0, 0)
    private var cancellables = Set<AnyCancellable>()
    private var tokens: Set<AnyCancellable> = []
    private var cancellableTimer: AnyCancellable?
    private var lastKnownLocation: CLLocation?
    
    private let weatherDataSubject = PassthroughSubject<WeatherResponse, Never>()
    
    init(deviceLocationService: DeviceLocationService) {
        self.deviceLocationService = deviceLocationService
        self.weatherData = WeatherResponse()
        
        // Initializes the device location updates
        deviceLocationService.requestLocationUpdates()
        observeCoordinatesUpdates(from: deviceLocationService)
        observeLocationAccessDenied(from: deviceLocationService)
    }
    
    // Returns the current weather data
    var currentWeather: CurrentWeather {
        return weatherData.current
    }
    
    // Returns the current UV
    var currentUV: Int {
        return Int(weatherData.current.uvi.rounded())
    }
    
    // Returns the hourly weather
    var hourlyWeather: [HourlyWeather] {
        return weatherData.hourly
    }
    
    // Returns the device location
    var deviceLocation: String {
        locationName
    }
    
    // Creates a timer that toggles every hour. Fetches weather
    private func setupHourlyWeatherFetch() {
        
        cancellableTimer?.cancel()
        
        // One hour timer creation
        cancellableTimer = Timer.publish(every: 3600, tolerance: 10, on: .main, in: .default)
            .autoconnect()
            .sink { [weak self] _ in
                self?.fetchWeather()
            }
        if let cancellableTimer = cancellableTimer {
            cancellableTimer.store(in: &cancellables)
        }
    }
    
    // Function that calls the proxy and returns weather
    private func fetchWeather() {
        WeatherService.shared.getCurrentWeather(lat: coordinates.lat, lon: coordinates.lon)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    print("Error fetching weather data: \(error.localizedDescription)")
                }
            }, receiveValue: { [weak self] weather in
                
                // Sets the weatherData values and sends information to UserManager
                self?.weatherData = weather
                self?.weatherDataSubject.send(weather)
            })
            .store(in: &cancellables)
    }
    
    // Function that updates the device coordinates
    private func observeCoordinatesUpdates(from deviceLocationService: DeviceLocationService) {
        deviceLocationService.coordinatesPublisher
            .receive(on: DispatchQueue.main)
            .sink { completion in
                if case .failure(let error) = completion {
                    print(error)
                }
            } receiveValue: { coordinates in
                // Sets the current device coordinates.
                self.coordinates = (coordinates.latitude, coordinates.longitude)
                
                // If it's the first fetch, then it'll call for a weather update and create a timer.
                if self.isFirstFetch {
                    self.fetchWeather()
                    self.isFirstFetch = false
                    self.setupHourlyWeatherFetch()
                }
                
                // Function to throttle and control the location name updates
                self.fetchLocationNameThrottle()
            }
            .store(in: &tokens)
    }
    
    // Calls for a location name update if device has moved.
    private func fetchLocationNameThrottle() {
        let newLocation = CLLocation(latitude: coordinates.lat, longitude: coordinates.lon)
        if let lastLocation = self.lastKnownLocation, newLocation.distance(from: lastLocation) < 100 {
            return
        }
        self.lastKnownLocation = newLocation
        self.fetchLocationName()
    }
    
    // Sends an error if the device no longer has access to the device location.
    private func observeLocationAccessDenied(from deviceLocationService: DeviceLocationService) {
        deviceLocationService.deniedLocationAccessPublisher
            .receive(on: DispatchQueue.main)
            .sink {
                print("Show some kind of alert to the user")
            }
            .store(in: &tokens)
    }
    
    // Retrieves the location name based on the device coordinates
    private func fetchLocationName() {
        let location = CLLocation(latitude: coordinates.lat, longitude: coordinates.lon)
        geocoder.reverseGeocodeLocation(location) { [weak self] placemarks, error in
            if let error = error {
                print("Error fetching location name: \(error.localizedDescription)")
                self?.locationName = "Unknown Location"
            } else if let placemark = placemarks?.first {
                self?.locationName = placemark.locality ?? "Unknown Location"
            }
        }
    }
    
    // Function that sends weather data to UserManager
    func weatherDataPublisher() -> AnyPublisher<WeatherResponse, Never> {
            return weatherDataSubject.eraseToAnyPublisher()
        }
    
    // Function that resets the weather timer.
    func resetWeatherFetch() {
        self.isFirstFetch = true
    }
}
