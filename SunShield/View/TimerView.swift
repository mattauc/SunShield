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
    
    var body: some View {
        GroupBox {
            Text("\(formattedTime)")
                .bold()
                .font(.custom("DIGITALDREAM", size: 22))
                .padding(.top, 1)
                .foregroundColor(colourScheme)
                .shadow(color: colourScheme, radius:2)
                .background(RoundedRectangle(cornerRadius: 10)
                    .fill(colourScheme)
                    .opacity(0.1)
                    .frame(width:150,height: 35))
                .frame(height: 30)
                
            
        } label: {
            Text("\(Image(systemName: "clock")) Reapplication")
        }
        .groupBoxStyle(.custom)
    }
    
    var formattedTime: String {
        guard let startTime = startTime else { return "00:00:00" }
        let elapsed = Int(Date().timeIntervalSince(startTime))
        var seconds = (userManager.timeToReapply) - elapsed
        if seconds <= 0 {
            self.startTime = nil
            seconds = 0
        }
        let hh = seconds / 3600
        let mm = (seconds % 3600) / 60
        let ss = (seconds % 3600) % 60
        return String(format: "%02d:%02d:%02d", hh, mm, ss)
    }
}
