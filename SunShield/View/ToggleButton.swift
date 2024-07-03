//
//  ToggleButton.swift
//  SunShield
//
//  Created by Matthew Auciello on 28/6/2024.
//

import SwiftUI

struct ToggleButton: View {
    var colour: Color
    var skinType: String
    var active = false
    
    private let cornerRadius: CGFloat = 5
    private let frameWidth: CGFloat = 100
    private let inactiveFrameWidth: CGFloat = 10
    private let frameHeight: CGFloat = 40
    private let inactiveOpacity: CGFloat = 0.1
    private let textOpacity: CGFloat = 0.2

    // Skin button toggle logic
    var body: some View {
        ZStack(alignment: .leading) {
            RoundedRectangle(cornerRadius: cornerRadius)
                .frame(width: frameWidth, height: frameHeight)
                .foregroundColor(Color.white.opacity(inactiveOpacity))
                .overlay(Text(skinType)
                    .opacity(textOpacity))
            
            // Completion bar
            RoundedRectangle(cornerRadius: cornerRadius)
                .frame(width: active ? frameWidth : inactiveFrameWidth, height: frameHeight)
                .foregroundColor(colour)
                .alignmentGuide(.leading) { d in
                    d[.leading]
                }
            
        }
    }
}

#Preview {
    ToggleButton(colour: Color(red: 1.0, green: 0.4, blue: 0.2), skinType: "TYPE IV")
}
