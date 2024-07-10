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
    private let weatherService: WeatherService
    private var geocoder = CLGeocoder()
    @Published private var locationName: String = "Loading..."
    private var isFirstFetch: Bool = true
    
        
    private var coordinates: (lat: Double, lon: Double) = (0, 0)
    private var cancellables = Set<AnyCancellable>()
    private var tokens: Set<AnyCancellable> = []
    private var cancellableTimer: AnyCancellable?
    private var lastKnownLocation: CLLocation?
    
    private let weatherDataSubject = PassthroughSubject<WeatherResponse, Never>()
    
    init(deviceLocationService: DeviceLocationService, weatherService: WeatherService) {
        self.deviceLocationService = deviceLocationService
        self.weatherService = weatherService
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
    
    var dailyWeather: [DailyWeather] {
        return weatherData.daily
    }
    
    // Returns the device location
    var deviceLocation: String {
        locationName
    }
    
    // Returns the current sunrise
    var sunrise: String {
        getTime(weatherData.current.sunrise)
    }
    
    var sunrisedt: Int {
        weatherData.current.sunrise
    }
    
    // Returns the current sunset
    var sunset: String {
        getTime(weatherData.current.sunset)
    }
    
    var sunsetdt: Int {
        weatherData.current.sunset
    }
    
    // Returns the current cloud percentage
    var clouds: Int {
        return weatherData.current.clouds
    }
    
    // Function to get the maximum UV index in the next 12 hours
    func getMaxUVIndexInNext24Hours() -> Double {
        let currentTime = weatherData.current.dt
        let hoursLater = currentTime + (24 * 60 * 60)
        
        let next24Hours = weatherData.hourly.filter { $0.dt >= currentTime && $0.dt <= hoursLater }
        return next24Hours.map { $0.uvi }.max() ?? 0.0
    }
    
    // Converts unix time to 24 hour time
    func getTime(_ unixTimestamp: Int) -> String {
        let date = Date(timeIntervalSince1970: TimeInterval(unixTimestamp))
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateFormat = "ha"
        let formattedDate = dateFormatter.string(from: date)
        return formattedDate
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
    func fetchWeather() {
        weatherService.getCurrentWeather(lat: coordinates.lat, lon: coordinates.lon)
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
                    self.fetchLocationName()
                }
                
            }
            .store(in: &tokens)
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
