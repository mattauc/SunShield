//
//  ContentView.swift
//  SunShield
//
//  Created by Matthew Auciello on 19/6/2024.
//

import Combine
import SwiftUI

struct SunShieldInterface: View {

    @AppStorage("isWelcomeScreenOver") var isWelcomeScreenOver = false
    @State var checkWelcomeScreen: Bool = false
    
    @ObservedObject var weatherManager = WeatherManager(deviceLocationService: DeviceLocationService.shared)
    
    var body: some View {
        VStack {
            if checkWelcomeScreen {
                coordinateView
                
            } else {
                WelcomeView()
            }
            
        }
        .onAppear {
            checkWelcomeScreen = isWelcomeScreenOver
        }
    }
    
    var coordinateView: some View {
        VStack {
            Text("CONTENT VIEW")
                .font(.largeTitle)
            Button("Fetch Weather") {
                weatherManager.fetchWeather()
                weatherManager.uvIndex()
//                Task {
//                    await
//                }
            }
        }
    }
}

#Preview {
    SunShieldInterface()
}
