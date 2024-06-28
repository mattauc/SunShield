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
    
    var body: some View {
        ZStack(alignment: .leading) {
            RoundedRectangle(cornerRadius: 5)
                .frame(width: 100, height: 40)
                .foregroundColor(Color.white.opacity(0.1))
                .overlay(Text(skinType)
                    .opacity(0.2))
            
            RoundedRectangle(cornerRadius: 5)
                .frame(width: active ? 100 : 10, height: 40)
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
