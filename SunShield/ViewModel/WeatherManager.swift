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

//Collected the location from the locationService
//Send that location data into the weatherAPI service
//Then send that data and store it in the weather model

class WeatherManager: ObservableObject {
    @Published private(set) var weatherData: Weather
    private let deviceLocationService: DeviceLocationService
    private var geocoder = CLGeocoder()
    @Published private var locationName: String = "Loading..."
    
        
    private var coordinates: (lat: Double, lon: Double) = (0, 0)
    private var cancellables = Set<AnyCancellable>()
    private var tokens: Set<AnyCancellable> = []
    
    private let weatherDataSubject = PassthroughSubject<Weather, Never>()
    
    init(deviceLocationService: DeviceLocationService) {
        self.deviceLocationService = deviceLocationService
        self.weatherData = Weather()
        
        deviceLocationService.requestLocationUpdates()
        observeCoordinatesUpdates(from: deviceLocationService)
        observeLocationAccessDenied(from: deviceLocationService)
    }
    
    func fetchWeather() async {
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
                self.fetchLocationName()
            }
            .store(in: &tokens)
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
    
    func weatherDataPublisher() -> AnyPublisher<Weather, Never> {
            return weatherDataSubject.eraseToAnyPublisher()
        }
    
    var weather: Weather {
        return weatherData
    }
    
    var weatherInfo: String {
        return "UVI: \(weatherData.uvi) | Clouds: \(weatherData.clouds) | Temp: \(weatherData.temp)"
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
