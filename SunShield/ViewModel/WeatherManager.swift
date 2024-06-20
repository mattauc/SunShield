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
    
    @Published private var weatherModel: Weather
    private let weatherService = WeatherService()
    
    private var coordinates: (lat: Double, lon: Double) = (0, 0)
    private var cancellables = Set<AnyCancellable>()
    private var tokens: Set<AnyCancellable> = []
    
    init(deviceLocationService: DeviceLocationService) {
        self.weatherModel = WeatherManager.createWeather()
        observeCoordinatesUpdates(from: deviceLocationService)
        observeLocationAccessDenied(from: deviceLocationService)
        deviceLocationService.requestLocationUpdates()
    }
    
    private static func createWeather() -> Weather {
        return Weather(temp: 0.0, uvi: 0.0, clouds: 0)
    }
    
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
                // Update weatherModel with fetched data
                self?.weatherModel = weather
            })
            .store(in: &cancellables)
    }
    
    func uvIndex() {
        print("UVI: \(weatherModel.uvi) | Clouds: \(weatherModel.clouds) | Temp: \(weatherModel.temp)")
    }
    
    func observeCoordinatesUpdates(from deviceLocationService: DeviceLocationService) {
        deviceLocationService.coordinatesPublisher
            .receive(on: DispatchQueue.main)
            .sink { completion in
                if case .failure(let error) = completion {
                    print(error)
                    print("HERE 1.0")
                }
            } receiveValue: { coordinates in
                self.coordinates = (coordinates.latitude, coordinates.longitude)
                print(coordinates)
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
}
