//
//  ContentView.swift
//  SunShield
//
//  Created by Matthew Auciello on 19/6/2024.
//

import Combine
import SwiftUI
import UserNotifications

struct SunShieldInterface: View {

    @AppStorage("isWelcomeScreenOver") var isWelcomeScreenOver = false
    @State var checkWelcomeScreen: Bool = false
    @State var showSettings: Bool = false
    @State var startTime: Date?
    @State var scrollOffset = 0.0
    
    @EnvironmentObject var weatherManager: WeatherManager
    @EnvironmentObject var userManager: UserManager
    
    var body: some View {
        ZStack {
            if checkWelcomeScreen {
                homeContentTabView
            } else {
                WelcomeView()
                    .onAppear() {
                        UNUserNotificationCenter.current().requestAuthorization(options: [.badge, .sound, .alert]) { (_, _) in
                        }
                    }
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
    
    var homeContentTabView: some View {
        NavigationStack {
            homeView
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(LinearGradient(gradient: Gradient(colors: [colourScheme.opacity(0.3), Color.clear]), startPoint: .top, endPoint: .bottom).edgesIgnoringSafeArea(.all))
                .animation(.easeInOut, value: colourScheme)
                .navigationDestination(isPresented: $showSettings) {
                    SettingsPage(accentColour: colourScheme)
                }
                .toolbar {
                    Button {
                        showSettings = true
                    } label: {
                        Image(systemName: "gearshape")
                    }
                }
            
        }
        .accentColor(colourScheme)
    }

    var homeView: some View {
        ZStack {
            ScrollView(.vertical, showsIndicators: false) {
                VStack {
                    VStack(alignment: .center, spacing: 5) {
                        currentWeather
                            .opacity(getTitleOpacity())
                    }
                    .offset(y: -scrollOffset)
                    .offset(y: scrollOffset > 0 ? (scrollOffset / UIScreen.main.bounds.width) * 100 : 0)
                    .offset(y: getTitleOffset()+20)
                    VStack(spacing: 8) {
                        CardContent(colourScheme: getColourScheme, weatherIcon: getWeatherCondition)
                    }
                }
                .padding(.top, 25)
                .padding([.horizontal])
                .overlay(
                    GeometryReader { proxy -> Color in
                        let minY = proxy.frame(in: .global).minY
                        DispatchQueue.main.async {
                            self.scrollOffset = minY
                        }
                        return Color.clear
                    })
            }
        }
        //NEED RATE LIMITING - ONE CALL PER HOUR
//        .refreshable {
//            await weatherManager.fetchWeather()
//            userManager.subscribeToWeatherUpdates(from: weatherManager)
//        }
    }
    
    func getTitleOpacity() -> CGFloat {
        let titleOffset = -getTitleOffset()
        let progress = titleOffset / 20
        let opacity = 1 - progress
        return opacity
    }
    
    func getTitleOffset() -> CGFloat {
        if scrollOffset < 0 {
            let progress = -scrollOffset / 120
            let newOffset = (progress <= 1.0 ? progress : 1) * 20
            return -newOffset
        }
        return 0.0
    }
    
    var currentWeather: some View {
        VStack {
            Text(weatherManager.deviceLocation)
                .font(.title)
                .bold()
            
            Text(String(Int(weatherManager.currentWeather.uvi.rounded())))
                .font(.system(size: 100))
                .uvIndexMod(UVIndex: weatherManager.currentUV, colourScheme: colourScheme)
                .padding(.horizontal, 100)
                .padding(.bottom, 10)
            Text("UV")
                .font(.title2)
                .bold()
                .padding(.bottom, 2)
        
            Text("\(weatherCondition) / " + String(Int(weatherManager.currentWeather.temp.rounded())) + "°C")
            
        }
        .padding([.top, .horizontal])
    }
    
    private var weatherCondition: String {
        if let condition = weatherManager.currentWeather.main {
            return getWeatherCondition(weather: condition)
        }
        return "💨"
    }
    
    private var colourScheme: Color {
        return getColourScheme(UV: weatherManager.currentUV)
    }
    
    func getColourScheme(UV: Int) -> Color {
        switch UV {
        case 0..<1:
            return .blue
        case 1..<3:
            return .green
        case 3..<5:
            return .yellow
        case 5..<7:
            return .red
        case 7..<10:
            return .indigo
        case 10...12:
            return .purple
        default:
            return .gray
        }
    }
    
    func getWeatherCondition(weather: String) -> String {
        switch weather {
        case "Clear":
            return "☀️"
        case "Clouds":
            return "☁️"
        case "Snow":
            return "❄️"
        case "Rain":
            return "🌧️"
        case "Drizzle":
            return "🌦️"
        case "Thunderstorm":
            return "⛈️"
        default:
            return "💨"
        }
    }
}

#Preview {
    SunShieldInterface()
        .environmentObject(UserManager())
        .environmentObject(WeatherManager(deviceLocationService: DeviceLocationService.shared))
}
