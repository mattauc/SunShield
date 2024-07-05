//
//  UVIndexView.swift
//  SunShield
//
//  Created by Matthew Auciello on 21/6/2024.
//

import SwiftUI

// View modifier for the primary UV Index information
struct UVIndexModifier: ViewModifier {
    var UVIndex: Int
    var colour: Color
    
    private let lineWidth: CGFloat = 18
    private let backgroundOpacity: CGFloat = 0.3
    private let rotationDegrees: Double = -90
    private let radius: CGFloat = 150
    
    // Circle progress bar logic
    func body(content: Content) -> some View {
        ZStack {
            Circle()
                .stroke(colour.opacity(backgroundOpacity), lineWidth: lineWidth)
                .frame(width: radius, height: radius)
            
            Circle()
                .trim(from: 0, to: CGFloat(UVIndex) / 12)
                .stroke(
                    AngularGradient(gradient: Gradient(colors: [colour, colour.opacity(1)]), center: .center),
                    style: StrokeStyle(lineWidth: lineWidth, lineCap: .round)
                )
                .rotationEffect(Angle(degrees: rotationDegrees))
                .frame(width: radius, height: radius)
            content
        }
    }
}

extension View {
    func uvIndexMod(UVIndex: Int, colourScheme: Color) -> some View {
        self.modifier(UVIndexModifier(UVIndex: UVIndex, colour: colourScheme))
    }
}

