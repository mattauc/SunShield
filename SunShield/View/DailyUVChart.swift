//
//  DailyUVChart.swift
//  SunShield
//
//  Created by Matthew Auciello on 23/6/2024.
//

import SwiftUI

// Displays the Hourly/Daily weather information
struct DailyUVChart: View {
    
    @EnvironmentObject var weatherManager: WeatherManager
    var colourScheme: (Int) -> Color
    var weatherIcon: (String) -> String
    @State var dayView: Bool = true
    var dayHours: Int = 82800
    
    // Creates the hourly weather card
    var body: some View {
        ZStack {
            GroupBox {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 16) {
                        ForEach(weatherManager.hourlyWeather.prefix(24), id: \.dt) { UVIndex in
                            
                            // Logic to hide night time values
                            if UVIndex.dt >= weatherManager.sunrisedt && UVIndex.dt <= weatherManager.sunsetdt {
                                weatherCell(UVIndex: UVIndex)
                            } else if UVIndex.dt >= (weatherManager.sunrisedt + dayHours) {
                                weatherCell(UVIndex: UVIndex)
                            }
                        }
                    }
                }
            } label: {
                Text("\(Image(systemName: "clock")) Hourly UV forecast")
                Divider()
            }
            .groupBoxStyle(.custom)
        }
    }
    
    // View for each weather cell
    @ViewBuilder
    func weatherCell(UVIndex: HourlyWeather) -> some View {
        let uvIndex = Int(UVIndex.uvi.rounded())
        let uvTemp = Int(UVIndex.temp.rounded())
        
        if let status = UVIndex.main {
            Text(String(uvIndex))
                .UVForecastMod(time: UVIndex.dt, colour: self.colourScheme(uvIndex), UVOffset: CGFloat(uvIndex), weatherIcon: self.weatherIcon(status), temp: uvTemp)
        } else {
            EmptyView()
        }
    }
}

// View modifier for the hourly forecast information
struct UVForecast: ViewModifier {
    var UVOffset: CGFloat
    var time: Int
    var colour: Color
    var lineWidth: CGFloat = 2
    var weatherIcon: String
    var temp: Int
    let radius: CGFloat = 30
    
    @EnvironmentObject var weatherManager: WeatherManager
    @State var dayView: Bool = true
    
    // Creates the weather information per hour
    func body(content: Content) -> some View {
        VStack {
            let sunrise = weatherManager.sunrise
            let sunset = weatherManager.sunset
            let currentTime = weatherManager.getTime(time)
            
            Group {
                Text("\(weatherIcon)")
                    .font(.caption)
                if sunrise == currentTime || sunset == currentTime {
                    ZStack {
                        Circle()
                            .stroke(colour.opacity(0), lineWidth: lineWidth)
                            .frame(width: radius, height: radius)
                        Image(systemName: sunrise == currentTime ? "sunrise.fill" : "sunset.fill")
                        
                    }
                } else {
                    ZStack {
//                        Circle()
//                            .stroke(colour.opacity(1), lineWidth: lineWidth)
//
                        content
                            .uvIndexMod(UVIndex: Int(UVOffset), colourScheme: colour, radius: radius, lineWidth: lineWidth)
                            //.frame(width: radius, height: radius)
                        
                    }
                }
            }
            .font(.title3)
            Text("\(temp)°C")
                .font(.caption2)
            Text(currentTime)
                .font(.caption)
                .foregroundColor(.white)
                .opacity(0.5)
        }
    }
}

extension View {
    func UVForecastMod(time: Int, colour: Color, UVOffset: CGFloat, weatherIcon: String, temp: Int) -> some View {
        self.modifier(UVForecast(UVOffset: UVOffset, time: time, colour: colour, weatherIcon: weatherIcon, temp: temp))
    }
}
