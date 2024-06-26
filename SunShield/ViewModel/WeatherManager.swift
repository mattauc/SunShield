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
        
        deviceLocationService.requestLocationUpdates()
        observeCoordinatesUpdates(from: deviceLocationService)
        observeLocationAccessDenied(from: deviceLocationService)
    }
    
    func setupHourlyWeatherFetch() {
        
        cancellableTimer?.cancel()
        
        cancellableTimer = Timer.publish(every: 3600, tolerance: 10, on: .main, in: .default)
            .autoconnect()
            .sink { [weak self] _ in
                self?.fetchWeather()
            }
        if let cancellableTimer = cancellableTimer {
            cancellableTimer.store(in: &cancellables)
        }
    }
    
    func fetchWeather() {
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
                self?.weatherData = weather
                self?.weatherDataSubject.send(weather)
            })
            .store(in: &cancellables)
    }
    
    func observeCoordinatesUpdates(from deviceLocationService: DeviceLocationService) {
        deviceLocationService.coordinatesPublisher
            .receive(on: DispatchQueue.main)
            .sink { completion in
                if case .failure(let error) = completion {
                    print(error)
                }
            } receiveValue: { coordinates in
                
                self.coordinates = (coordinates.latitude, coordinates.longitude)
                if self.isFirstFetch {
                    self.fetchWeather()
                    self.isFirstFetch = false
                    self.setupHourlyWeatherFetch()
                }
                self.fetchLocationNameThrottle()
            }
            .store(in: &tokens)
    }
    
    func fetchLocationNameThrottle() {
        let newLocation = CLLocation(latitude: coordinates.lat, longitude: coordinates.lon)
        if let lastLocation = self.lastKnownLocation, newLocation.distance(from: lastLocation) < 100 {
            return
        }
        self.lastKnownLocation = newLocation
        self.fetchLocationName()
    }

    func observeLocationAccessDenied(from deviceLocationService: DeviceLocationService) {
        deviceLocationService.deniedLocationAccessPublisher
            .receive(on: DispatchQueue.main)
            .sink {
                print("Show some kind of alert to the user")
            }
            .store(in: &tokens)
    }
    
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
    
    func weatherDataPublisher() -> AnyPublisher<WeatherResponse, Never> {
            return weatherDataSubject.eraseToAnyPublisher()
        }
    
    func resetWeatherFetch() {
        self.isFirstFetch = true
    }

    var currentWeather: CurrentWeather {
        return weatherData.current
    }
    
    var currentUV: Int {
        return Int(weatherData.current.uvi.rounded())
    }
    
    var hourlyWeather: [HourlyWeather] {
        return weatherData.hourly
    }
    
    var locationLoaded: Bool {
        if coordinates.lat == 0.0 && coordinates.lon == 0.0 {
            return false
        }
        return true
    }
    
    var deviceLocation: String {
        locationName
    }
}
