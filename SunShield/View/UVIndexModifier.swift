//
//  UVIndexView.swift
//  SunShield
//
//  Created by Matthew Auciello on 21/6/2024.
//

import SwiftUI

struct UVIndexModifier: ViewModifier {
    
    var UVIndex: Int
    var colour: Color
    
    private let lineWidth: CGFloat = 15
    private let backgroundOpacity: CGFloat = 0.3
    private let rotationDegrees: Double = -90
    
    func body(content: Content) -> some View {
        ZStack {
            Circle()
                .stroke(colour.opacity(backgroundOpacity), lineWidth: lineWidth)
            
            Circle()
                .trim(from: 0, to: CGFloat(UVIndex) / 12)
                .stroke(
                    AngularGradient(gradient: Gradient(colors: [colour, colour.opacity(1)]), center: .center),
                    style: StrokeStyle(lineWidth: lineWidth, lineCap: .round)
                )
                .rotationEffect(Angle(degrees: rotationDegrees))
            content
        }
    }
}

extension View {
    func uvIndexMod(UVIndex: Int, colourScheme: Color) -> some View {
        self.modifier(UVIndexModifier(UVIndex: UVIndex, colour: colourScheme))
    }
}

