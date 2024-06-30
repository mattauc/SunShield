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
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack {
                UVCard
                HStack{
                    spfSelection

                    TimerView(colourScheme: colourScheme(weatherManager.currentUV), startTime: $startTime)
                }
                TimerButtons(colourScheme: self.colourScheme(weatherManager.currentUV), startTime: $startTime)
                DailyUVChart(colourScheme: self.colourScheme, weatherIcon: self.weatherIcon)
            }
            .animation(.easeInOut, value: weatherManager.currentWeather.dt)
        }
    }
    
    var spfSelection: some View {
        GroupBox {
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    ForEach(Array(userManager.spfTypes.enumerated()), id: \.element.id) { index, type in
                        Text(type.id)
                            .font(.largeTitle)
                            .bold()
                            .padding()
                            .containerRelativeFrame(.horizontal, count: 1, spacing: 1)
                            .background(SPFSelected == index ? Capsule()
                                
                                .fill(colourScheme(weatherManager.currentUV))
                                .padding()
                                .opacity(0.5) : nil)
                            
                            .onTapGesture {
                                SPFSelected = index
                                userManager.updateUserSPF(spf: type)
                            }
                    }
                }
                .scrollTargetLayout()
            }
            .frame(height: 30)
            .scrollTargetBehavior(.viewAligned)
        } label: {
            Text("\(Image(systemName: "sun.max")) Sunscreen SPF")
        }
        .groupBoxStyle(.custom)
    }
    
    var UVCard: some View {
        GroupBox {
            HStack {
                Button {
                    UVInformation = true
                } label: {
                    Image(systemName: "info.circle")
                }
                .font(.title2)
                .navigationDestination(isPresented: $UVInformation) {
                    UVIndexInfo()
                }
                Text(UVDescription + " Index")
                    .font(.title2)
                    .bold()
                Spacer()
                Text(String(Int(weatherManager.currentWeather.uvi.rounded())))
                    .font(.title)
                    .frame(width: 65, height: 50)
                    .background(Capsule()
                        .fill(colourScheme(weatherManager.currentUV))
                        .opacity(0.5))
            }
            .frame(height: 30)
        }
        .groupBoxStyle(.custom)
    }
    
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

struct CustomGroupBox: GroupBoxStyle {
    func makeBody(configuration: Configuration) -> some View {
        VStack(alignment: .leading) {
            configuration.label
                .bold()
                .font(.callout)
            configuration.content
            
        }
        .padding()
        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 15))
    }
}

extension GroupBoxStyle where Self == CustomGroupBox {
    static var custom: CustomGroupBox { .init() }
}

