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
    @State var weatherTime: Date?
    @State var scrollOffset = 0.0
    
    @EnvironmentObject var weatherManager: WeatherManager
    @EnvironmentObject var userManager: UserManager
    @Environment(\.scenePhase) var scenePhase

    private let titleOffsetProgress: CGFloat = 120
    private let titleOffsetMax: CGFloat = 20
    private let titleOpacityProgress: CGFloat = 20
    private let uvIndexFontSize: CGFloat = 100
    
    var body: some View {
        ZStack {
            
            // Logic to dispaly the welcome screen
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
        
        // Subscribes to weather updates
        .onAppear {
            checkWelcomeScreen = isWelcomeScreenOver
            userManager.subscribeToWeatherUpdates(from: weatherManager)
        }
        
        // Resets the weather timer when user returns from the background
        .onChange(of: scenePhase) { oldPhase, newPhase in
            if oldPhase == .background {
                weatherManager.resetWeatherFetch()
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
    
    // Returns the primary home view with UV information
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
                    .offset(y: getTitleOffset()+titleOffsetMax)
                    
                    // Card content is dispalyed below the primary view
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
    }
    
    // Tool used for scrolling effect
    func getTitleOpacity() -> CGFloat {
        let titleOffset = -getTitleOffset()
        let progress = titleOffset / titleOpacityProgress
        let opacity = 1 - progress
        return opacity
    }
    
    // Tool used for scrolling effect
    func getTitleOffset() -> CGFloat {
        if scrollOffset < 0 {
            let progress = -scrollOffset / titleOffsetProgress
            let newOffset = (progress <= 1.0 ? progress : 1) * titleOffsetMax
            return -newOffset
        }
        return 0.0
    }
    
    // View that builds the current weather primary view
    var currentWeather: some View {
        VStack {
            Text(weatherManager.deviceLocation)
                .font(.title)
                .bold()
            
            Text(String(Int(weatherManager.currentWeather.uvi.rounded())))
                .font(.system(size: uvIndexFontSize))
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
    
    // Returns the current weather condition
    private var weatherCondition: String {
        if let condition = weatherManager.currentWeather.main {
            return getWeatherCondition(weather: condition)
        }
        return "💨"
    }
    
    // Returns the corresponding colour scheme
    private var colourScheme: Color {
        return getColourScheme(UV: weatherManager.currentUV)
    }
    
    func getColourScheme(UV: Int) -> Color {
        switch UV {
        case 0..<3:
            return .blue
        case 3..<6:
            return .yellow
        case 6..<8:
            return .orange
        case 8..<11:
            return .red
        case 11..<15:
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
