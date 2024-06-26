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
    
    @State var scrollOffset = 0.0
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
                        content
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
        .refreshable {
            await weatherManager.fetchWeather()
            userManager.subscribeToWeatherUpdates(from: weatherManager)
        }
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
                .uvIndexMod(UVIndex: Int(weatherManager.currentWeather.uvi.rounded()), colourScheme: colourScheme)
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
    
    var content: some View {
        ScrollView(showsIndicators: false) {
            NavigationStack {
                VStack {
                    GroupBox {
                        UVCard
                    }
                    .groupBoxStyle(.custom)
            
                    HStack{
                        GroupBox {
                            spfSelection
                                .frame(height: 30)
                        } label: {
                            Text("\(Image(systemName: "sun.max")) Sunscreen SPF")
                            
                        }
                        .groupBoxStyle(.custom)
                        TimerView(colourScheme: colourScheme, startTime: $startTime)
                    }
                    TimerButtons(colourScheme: colourScheme, startTime: $startTime)
                    DailyUVChart(colourScheme: getColourScheme, weatherIcon: getWeatherCondition)
                }
            }
        }
    }
    
    @State var SPFSelected: Int = 0
    
    var spfSelection: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack {
                ForEach(Array(userManager.spfTypes.enumerated()), id: \.element.id) { index, type in
                    Text(type.id)
                        .font(.largeTitle)
                        .bold()
                        .containerRelativeFrame(.horizontal, count: 1, spacing: 1)
                        .background(SPFSelected == index ? Capsule().fill(colourScheme).opacity(0.5) : nil)
                        .onTapGesture {
                            SPFSelected = index
                            userManager.updateUserSPF(spf: type)
                        }
                }
            }
            .scrollTargetLayout()
        }
        .scrollTargetBehavior(.viewAligned)
    }
    
    @State var UVInformation: Bool = false
    
    var UVCard: some View {
        HStack {
            Button {
                UVInformation = true
            } label: {
                Image(systemName: "info.circle")
            }
            .font(.title2)
            .navigationDestination(isPresented: $UVInformation) {
                
            }
            Text(UVDescription + " Index")
                .font(.title2)
                .bold()
            Spacer()
            Text(String(Int(weatherManager.currentWeather.uvi.rounded())))
                .font(.title)
                .frame(width: 65, height: 50)
                .background(Capsule()
                    .fill(colourScheme)
                    .opacity(0.5))
                    
        }
        .frame(height: 30)
    }
    
    private var weatherCondition: String {
        if let condition = weatherManager.currentWeather.main {
            return getWeatherCondition(weather: condition)
        }
        return "💨"
    }
    
    private var colourScheme: Color {
        return getColourScheme(UV: Int(weatherManager.currentWeather.uvi.rounded()))
    }
    
    private var UVDescription: String {
        switch weatherManager.currentWeather.uvi {
        case 0..<3:
            return "VERY LOW"
        case 3..<5:
            return "LOW"
        case 5..<7:
            return "AVERAGE"
        case 7..<10:
            return "HIGH"
        case 10...12:
            return "VERY HIGH"
        default:
            return "ABANDON ALL HOPE"
        }
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
