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
    
    @EnvironmentObject var weatherManager: WeatherManager
    @EnvironmentObject var userManager: UserManager
    
    var body: some View {
        ZStack {
            if checkWelcomeScreen {
                homeContentTabView
            } else {
                WelcomeView()
            }
        }
        .onAppear {
            checkWelcomeScreen = isWelcomeScreenOver
            Task {
                await weatherManager.fetchWeather()
                userManager.subscribeToWeatherUpdates(from: weatherManager)
            }
        }
    }
    

    @State private var selectedTab = 1
    
    var homeContentTabView: some View {
        TabView(selection: $selectedTab) {
            Group {
                Text("Timer")
                    .tabItem {
                        Image(systemName: "timer")
                        Text("Timer")
                    }
                    .tag(0)
                homeView
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    //.background(Color.blue)
                    .background(LinearGradient(gradient: Gradient(colors: [Color.blue.opacity(0.3), Color.white]), startPoint: .top, endPoint: .bottom).edgesIgnoringSafeArea(.all))
                    .tabItem {
                        Image(systemName: "house")
                        Text("Home")
                    }
                    .tag(1)
                
                SettingsPage()
                    .tabItem {
                        Image(systemName: "list.bullet")
                        Text("Settings")
                    }
                    .tag(2)
            }
            .toolbarBackground(.visible, for: .tabBar)
        }
        
    }
    
    var homeView: some View {
        ScrollView {
            VStack {
                currentWeather
                //content
            }
        }
        .refreshable {
            await weatherManager.fetchWeather()
            userManager.subscribeToWeatherUpdates(from: weatherManager)
        }
    }
    
    var currentWeather: some View {
        VStack {
            Text(weatherManager.deviceLocation)
                .font(.largeTitle)
            GroupBox {
                Text(String(Int(weatherManager.weather.uvi.rounded())))
                    .font(.system(size: 100))
                Text("UV")
                    .font(.title3)
            }
            .background(.thinMaterial)
            Text("🌧️ / " + String(Int(weatherManager.weather.temp.rounded())) + "°C")
            
        }
        .padding()
    }
    
    var content: some View {
        ScrollView {
            VStack {
                GroupBox {
                    //Text(weatherManager.weatherInfo)
                }
            }
        }
    }
}

#Preview {
    SunShieldInterface()
}
