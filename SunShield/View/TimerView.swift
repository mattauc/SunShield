//
//  TimerView.swift
//  SunShield
//
//  Created by Matthew Auciello on 23/6/2024.
//

import SwiftUI

struct TimerView: View {
    
    var colourScheme: Color
    @EnvironmentObject var userManager: UserManager
    @Binding var startTime: Date?
    
    private let defaultTime: String = "00:00:00"
    private let timeFormat: String = "%02d:%02d:%02d"
    private let fontSize: CGFloat = 22
    private let textFrameHeight: CGFloat = 30
    private let frameWidth: CGFloat = 150
    private let frameHeight: CGFloat = 35

    
    var body: some View {
        GroupBox {
            Text("\(formattedTime)")
                .bold()
                .font(.custom("DIGITALDREAM", size: fontSize))
                .padding(.top, 1)
                .foregroundColor(colourScheme)
                .shadow(color: colourScheme, radius:2)
                .background(RoundedRectangle(cornerRadius: 10)
                    .fill(colourScheme)
                    .opacity(0.1)
                    .frame(width: frameWidth, height: frameHeight))
                .frame(height: textFrameHeight)
        } label: {
            Text("\(Image(systemName: "clock")) Reapplication")
        }
        .groupBoxStyle(.custom)
    }
    
    var formattedTime: String {
        guard let startTime = startTime else { return defaultTime }
        let elapsed = Int(Date().timeIntervalSince(startTime))
        let seconds = (userManager.timeToReapply) - elapsed
        if seconds <= 0 {
            return defaultTime
        }
        let hh = seconds / 3600
        let mm = (seconds % 3600) / 60
        let ss = (seconds % 3600) % 60
        return String(format: timeFormat, hh, mm, ss)
    }
}
