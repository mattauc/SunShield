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
    
    @Published private var weather = Weather()
    
    private var coordinates: (lat: Double, lon: Double) = (0, 0)
    private var tokens: Set<AnyCancellable> = []
    
    init(deviceLocationService: DeviceLocationService) {
        observeCoordinatesUpdates(from: deviceLocationService)
        observeLocationAccessDenied(from: deviceLocationService)
        deviceLocationService.requestLocationUpdates()
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
