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
    private let timeFormat = "%02d:%02d:%02d"
    private let fontSize: CGFloat = 50
    private let textFrameHeight: CGFloat = 40

    // Displays the primary timer
    var body: some View {
        ZStack {
            Text("\(formattedTime)")
                .bold()
                .font(.custom("DIGITALDREAM", size: fontSize))
                .padding(.top, 1)
                .foregroundColor(colourScheme)
                .shadow(color: colourScheme, radius:2)
                .minimumScaleFactor(0.5)
        }
        .padding()
    }
    
    // Formats the timer time
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
