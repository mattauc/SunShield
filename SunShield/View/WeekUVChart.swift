//
//  WeekUVChart.swift
//  SunShield
//
//  Created by Matthew Auciello on 6/7/2024.
//

import SwiftUI

struct WeekUVChart: View {
    
    @EnvironmentObject var weatherManager: WeatherManager
    var colourScheme: (Int) -> Color
    var weatherIcon: (String) -> String
    
    var body: some View {
        ZStack {
            GroupBox {
                VStack(spacing: 16) {
                    ForEach(weatherManager.dailyWeather.dropFirst().prefix(7), id: \.dt) { day in
                        let dailyUV = Int(day.uvi.rounded())
                        
                        if let status = day.main {
                            Text(String(dailyUV))
                                .dailyCellModifier(date: day.dt, weatherIcon: weatherIcon(status), uv: day.uvi, temp: day.temp.max, colour: colourScheme(dailyUV))
                        }
                    }
                }
            } label: {
                Text("\(Image(systemName: "calendar")) Daily UV forecast")
                Divider()
            }
            .groupBoxStyle(.custom)
        }
    }
}

struct dailyCell: ViewModifier {
    var date: Int
    var weatherIcon: String
    var uv: Double
    var temp: Double
    var colour: Color
    
    func body(content: Content) -> some View {
            HStack {
                Group {
                    Text(String(getDay(date)))
                        .opacity(0.8)
                    Text(weatherIcon)
                    Text("\(Int(temp.rounded()))°C")
                    UVProgressBar(colour: colour, uv: uv)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                content
                    .frame(width: 20)
            }
        }
    
    // Function to get the day from unix time
    func getDay(_ unixDate: Int) -> String {
        let date = Date(timeIntervalSince1970: TimeInterval(unixDate))
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEE"
        return dateFormatter.string(from: date)
    }
}

// Custom progress bar view
struct UVProgressBar: View {
    var colour: Color
    var uv: Double
    var progressBarWidth: CGFloat = 135
    var maxUVIndex: Double = 13.0
    var barHeight: CGFloat = 10
    var cornerRadius: CGFloat = 4
    
    var body: some View {
        ZStack(alignment: .leading) {
            RoundedRectangle(cornerRadius: cornerRadius)
                .fill(Color.gray.opacity(0.5))
                .frame(width: progressBarWidth, height: barHeight)
        
            RoundedRectangle(cornerRadius: cornerRadius)
                .fill(colour)
                .frame(width: CGFloat((uv / maxUVIndex)) * progressBarWidth, height: barHeight)
                .animation(.easeInOut(duration: 1.0), value: uv)
        }
    }
}

extension View {
    func dailyCellModifier(date: Int, weatherIcon: String, uv: Double, temp: Double, colour: Color) -> some View {
        self.modifier(dailyCell(date: date, weatherIcon: weatherIcon, uv: uv, temp: temp, colour: colour))
    }
}
