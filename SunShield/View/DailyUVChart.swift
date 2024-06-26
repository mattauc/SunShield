//
//  DailyUVChart.swift
//  SunShield
//
//  Created by Matthew Auciello on 23/6/2024.
//

import SwiftUI

struct DailyUVChart: View {
    
    @EnvironmentObject var weatherManager: WeatherManager
    var colourScheme: (Int) -> Color
    var weatherIcon: (String) -> String
    
    var body: some View {
        ZStack {
            GroupBox {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 16) {
                        ForEach(weatherManager.hourlyWeather, id: \.dt) { UVIndex in
                            let uvIndex = Int(UVIndex.uvi.rounded())
                            let uvTemp = Int(UVIndex.temp.rounded())
                            if let status = UVIndex.main {
                                Text(String(uvIndex))
                                    .UVForecastMod(time: UVIndex.dt, colour: self.colourScheme(uvIndex), UVOffset: CGFloat(uvIndex), weatherIcon: self.weatherIcon(status), temp: uvTemp)
                            }
                        }
                    }
                    .padding(.top)
                }
            } label: {
                Text("\(Image(systemName: "calendar")) Hourly UV forecast")
                Divider()
            }
            
        }
    }
}

struct UVForecast: ViewModifier {
    var UVOffset: CGFloat
    var time: Int
    var colour: Color
    var lineWidth: CGFloat = 2
    var weatherIcon: String
    var temp: Int
    
    func body(content: Content) -> some View {
        VStack {
            Group {
                Text("\(weatherIcon)")
                    .font(.caption)
                
                ZStack {
                    Circle()
                        .stroke(colour.opacity(1), lineWidth: lineWidth)
                    content
                }
                .font(.title3)
                Text("\(temp)°C")
                    .font(.caption2)
                    
            }
            .offset(y: UVOffset*(-2))
            Text(convertUnixTimestamp(unixTimestamp: time))
                .font(.caption)
                .foregroundColor(.white)
                .opacity(0.5)
        }
        .padding(.top)
    }
    
    func convertUnixTimestamp(unixTimestamp: Int) -> String {
        let date = Date(timeIntervalSince1970: TimeInterval(unixTimestamp))
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateFormat = "ha"
        let formattedDate = dateFormatter.string(from: date)
        return formattedDate
    }
}

extension View {
    func UVForecastMod(time: Int, colour: Color, UVOffset: CGFloat, weatherIcon: String, temp: Int) -> some View {
        self.modifier(UVForecast(UVOffset: UVOffset, time: time, colour: colour, weatherIcon: weatherIcon, temp: temp))
    }
}
//
//#Preview {
//    DailyUVChart(colour: .blue)
//        .environmentObject(WeatherManager(deviceLocationService: DeviceLocationService.shared))
//}
