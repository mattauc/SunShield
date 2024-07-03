//
//  UVIndexInfo.swift
//  SunShield
//
//  Created by Matthew Auciello on 29/6/2024.
//

import SwiftUI

struct UVIndexInfo: View {
    
    // Displays the UV index information page
    var body: some View {
        NavigationView {
            GroupBox {
                ScrollView() {
                    VStack {
                        buildUVTab(colour: .blue, range: "0-2", content: "Low danger from the sun's UV rays for the average person.", title: "Low")
                        Divider()
                        buildUVTab(colour: .yellow, range: "3-5", content: "Moderate risk of harm from unprotected sun exposure.", title: "Moderate")
                        Divider()
                        buildUVTab(colour: .orange, range: "6-7", content: "High risk of harm from unprotected sun exposure. Protection against skin and eye damage is needed.", title: "High")
                        Divider()
                        buildUVTab(colour: .red, range: "8-10", content: "Very high risk of harm from unprotected sun exposure. Take extra precautions because unrpotected skin and eyes will be damaged and can burn quickly.", title: "Very High")
                        Divider()
                        buildUVTab(colour: .purple, range: "11+", content: "Extreme risk of harm from unprotected sun exposure. Take all precautions because unprotected skin and eyes can burn in minutes", title: "Extreme")
                    }
                }
            } label: {
                Text("UV Information")
                    .font(.largeTitle)
                    .bold()
                Divider()
            }
            .groupBoxStyle(.custom)
            .ignoresSafeArea()
            .padding(.top)
        }
    }
    
    // Builds each individual UV tab
    func buildUVTab(colour: Color, range: String, content: String, title: String) -> some View {
        HStack {
            ZStack {
                RoundedRectangle(cornerRadius: 15)
                    .fill(colour)
                    .frame(width:100, height: 100)
                VStack {
                    Text(range)
                        .bold()
                        .font(.largeTitle)
                    Text(title)
                        .bold()
                        .font(.title3)
                }
            }
            VStack(alignment: .leading) {
                Text(content)
            }
            .padding()
        }
    }
}

#Preview {
    UVIndexInfo()
}
