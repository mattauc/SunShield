//
//  SwiftUIView.swift
//  SunShield
//
//  Created by Matthew Auciello on 23/6/2024.
//

import SwiftUI

struct TimerView: View {
    var colourScheme: Color
    @EnvironmentObject var userManager: UserManager
    @State var start: Bool = false
    
    var body: some View {
        HStack {
            restartButton
            startButton
                .onChange(of: userManager.timerCount) {
                    if userManager.timerCount == 0 {
                        self.Notification()
                        self.start.toggle()
                    }
                }
        }
    }
    
    var restartButton: some View {
        Button(action:  {
            userManager.restartTimer()
            if !self.start {
                self.start.toggle()
            }
        }) {
            HStack(spacing: 15) {
                Image(systemName: "arrow.clockwise")
                    .foregroundColor(.white)
                Text("Restart")
                    .foregroundColor(.white)
            }
            .padding(.vertical)
            .frame(width: (UIScreen.main.bounds.width / 2) - 55)
            .background(Capsule().stroke(Color(colourScheme), lineWidth: 2))
            .shadow(color: colourScheme, radius: 5)
        }
        .padding([.top, .bottom], 10)
    }
    
    var startButton: some View {
        Button(action:  {
            
            if self.start {
                userManager.pauseSunscreenTimer()
                
            } else {
                userManager.startSunscreenTimer()
            }
            self.start.toggle()
        }) {
            HStack(spacing: 15) {
                Image(systemName: self.start ? "pause.fill" : "play.fill")
                    .foregroundColor(.white)
                Text(self.start ? "Pause" : "Start")
                    .foregroundColor(.white)
            }
            .padding(.vertical)
            .frame(width: (UIScreen.main.bounds.width / 2) - 55)
            .background(colourScheme)
            .clipShape(Capsule())
            .shadow(color: colourScheme, radius: 5)
        }
        .padding([.top, .bottom], 10)
    }
    
    func Notification() {
        let content = UNMutableNotificationContent()
        content.title = "Reapply sunscreen"
        content.body = "Time to reapply sunscreen and stay protected under the sun."
        content.sound = UNNotificationSound.default
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
        let req = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(req, withCompletionHandler: nil)
    }
}

//#Preview {
//    TimerView()
//}
