//
//  ContentView.swift
//  SunShield
//
//  Created by Matthew Auciello on 19/6/2024.
//

import Combine
import SwiftUI

struct SunShieldInterface: View {
    
    @StateObject var deviceLocationService = DeviceLocationService.shared
    @AppStorage("isWelcomeScreenOver") var isWelcomeScreenOver = false
    @State var checkWelcomeScreen: Bool = false
    
    @State var tokens: Set<AnyCancellable> = []
    @State var coordinates: (lat: Double, lon: Double) = (0, 0)
    
    var body: some View {
        VStack {
            if checkWelcomeScreen {
                coordinateView
            } else {
                //Bindings for the location services fed into WelcomeView
                WelcomeView()
            }
            
        }
        .onAppear {
            checkWelcomeScreen = isWelcomeScreenOver
            observeCoordinatesUpdates()
            observeLocationAccessDenied()
            deviceLocationService.requestLocationUpdates()
        }
    }
    
    var coordinateView: some View {
        VStack {
            Text("Latitude: \(coordinates.lat)")
                .font(.largeTitle)
            Text("Longitude: \(coordinates.lon)")
                .font(.largeTitle)
        }
    }
    
    func observeCoordinatesUpdates() {
        deviceLocationService.coordinatesPublisher
            .receive(on: DispatchQueue.main)
            .sink { completion in
                if case .failure(let error) = completion {
                    print(error)
                }
            } receiveValue: { coordinates in
                self.coordinates = (coordinates.latitude, coordinates.longitude)
            }
            .store(in: &tokens)
    }
    
    func observeLocationAccessDenied() {
        deviceLocationService.deniedLocationAccessPublisher
            .receive(on: DispatchQueue.main)
            .sink {
                print("Show some kind of alert to the user")
            }
            .store(in: &tokens)
    }
}

#Preview {
    SunShieldInterface()
}
