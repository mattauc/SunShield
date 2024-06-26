//
//  SwiftUIView.swift
//  SunShield
//
//  Created by Matthew Auciello on 23/6/2024.
//

import SwiftUI

struct TimerButtons: View {
    var colourScheme: Color
    @EnvironmentObject var userManager: UserManager
    @Binding var startTime: Date?
    @State var start: Bool = false
    
    var body: some View {
        HStack {
            restartButton
            startButton
                .onChange(of: self.startTime) {
                    if self.startTime == nil {
                        userManager.stopSunscreenTimer()
                        self.start.toggle()
                    }
                }
        }
    }
    
    var startButton: some View {
        Button(action:  {
            if self.start {
                userManager.stopSunscreenTimer()
                self.startTime = nil
                UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
            } else {
                userManager.startSunscreenTimer()
                self.startTime = Date()
                self.sendNotification(time: userManager.timerCount)
                self.start.toggle()
            }
        }) {
            HStack(spacing: 15) {
                Image(systemName: self.start ? "stop.fill" : "play.fill")
                    .foregroundColor(.white)
                Text(self.start ? "Stop" : "Start")
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
    
    var restartButton: some View {
        Button(action:  {
            userManager.restartTimer()
            self.startTime = Date()
            if !self.start {
                self.start.toggle()
            }
            UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
            self.sendNotification(time: userManager.timerCount)
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
    
    
    func sendNotification(time: Int) {
        let content = UNMutableNotificationContent()
        content.title = "Reapply sunscreen"
        content.body = "Time to reapply sunscreen and stay protected under the sun."
        content.sound = UNNotificationSound.default
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: TimeInterval(time), repeats: false)
        let req = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(req, withCompletionHandler: nil)
    }
}
