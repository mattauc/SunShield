//
//  CardContent.swift
//  SunShield
//
//  Created by Matthew Auciello on 22/6/2024.
//

import SwiftUI

struct CardContent: View {
    
    @State var SPFSelected: Int = 0
    @State var UVInformation: Bool = false
    @State var startTime: Date?
    var colourScheme: (Int) -> Color
    var weatherIcon: (String) -> String
    
    
    @EnvironmentObject var userManager: UserManager
    @EnvironmentObject var weatherManager: WeatherManager
    
    private let cardHeight: CGFloat = 30
    private let uvIndexFrameWidth: CGFloat = 65
    private let uvIndexFrameHeight: CGFloat = 50
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            // VStack that encompasses all the content below the primary display
            VStack {
                UVCard
                DailyUVChart(colourScheme: self.colourScheme, weatherIcon: self.weatherIcon)
                WeekUVChart(colourScheme: self.colourScheme, weatherIcon: self.weatherIcon)
            }
        }
    }

    // UV information card
    var UVCard: some View {
        GroupBox {
            HStack {
                NavigationLink(destination: UVIndexInfo()) {
                    Image(systemName: "info.circle")
                }
                .font(.title2)
                Text(UVDescription + " Index")
                    .font(.title2)
                    .bold()
                Spacer()
                Text(String(Int(weatherManager.currentWeather.uvi.rounded())))
                    .font(.title)
                    .frame(width: uvIndexFrameWidth, height: uvIndexFrameHeight)
                    .background(Capsule()
                        .fill(colourScheme(weatherManager.currentUV))
                        .opacity(0.5))
            }
            .frame(height: cardHeight)
        }
        .groupBoxStyle(.custom)
    }
    
    // Returns the UV Description based off the current UV
    private var UVDescription: String {
        switch weatherManager.currentUV {
        case 0..<3:
            return "LOW"
        case 3..<6:
            return "MODERATE"
        case 6..<8:
            return "HIGH"
        case 8..<11:
            return "VERY HIGH"
        case 11...15:
            return "EXTREME"
        default:
            return "ABANDON ALL HOPE"
        }
    }
}

// Custom groupBox style
struct CustomGroupBox: GroupBoxStyle {
    func makeBody(configuration: Configuration) -> some View {
        VStack(alignment: .leading) {
            configuration.label
                .bold()
                .font(.callout)
            configuration.content
        }
        .padding()
        .background(RoundedRectangle(cornerRadius: 15)
            .fill(.gray)
            .opacity(0.2))
    }
}

extension GroupBoxStyle where Self == CustomGroupBox {
    static var custom: CustomGroupBox { .init() }
}

