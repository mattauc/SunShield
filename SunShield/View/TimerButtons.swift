//
//  SwiftUIView.swift
//  SunShield
//
//  Created by Matthew Auciello on 23/6/2024.
//

import SwiftUI

// Handles the timer logic and notifications
struct TimerButtons: View {
    var colourScheme: Color
    @EnvironmentObject var userManager: UserManager
    @Binding var startTime: Date?
    @State var start: Bool = false
    
    private let buttonSpacing: CGFloat = 20
    private let hStackPadding: CGFloat = 10
    private let buttonVerticalPadding: CGFloat = 15
    private let buttonHorizontalPadding: CGFloat = 55
    
    // Timer button view
    var body: some View {
        HStack(spacing: buttonSpacing) {
            restartButton
            startButton
                .onChange(of: userManager.timerCount) {newValue, oldValue in
                    if let startTime = startTime {
                        if newValue - Int(Date().timeIntervalSince(startTime)) < 0 {
                            userManager.stopSunscreenTimer()
                            self.startTime = nil
                            self.start.toggle()
                        }
                    }
                }
        }
    }
    
    // Start button
    var startButton: some View {
        
        // Button stops and starts the timer
        Button(action:  {
            if self.start {
                userManager.stopSunscreenTimer()
                self.startTime = nil
                UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
            } else {
                userManager.startSunscreenTimer()
                if userManager.timeToReapply == 0 {
                    return
                }
                self.startTime = Date()
                self.sendNotification(time: userManager.timerCount)
            }
            self.start.toggle()
        }) {
            HStack(spacing: buttonVerticalPadding) {
                Image(systemName: self.start ? "stop.fill" : "play.fill")
                    .foregroundColor(.primary)
                Text(self.start ? "Stop" : "Start")
                    .foregroundColor(.primary)
            }
            .padding(.vertical)
            .frame(width: (UIScreen.main.bounds.width / 2) - buttonHorizontalPadding)
            .background(colourScheme)
            .clipShape(Capsule())
            .shadow(color: colourScheme, radius: 2)
        }
        .padding([.top, .bottom], hStackPadding)
    }
    
    // Restart button
    var restartButton: some View {
        
        // Button restarts the timer when pressed
        Button(action:  {
            userManager.restartTimer()
            if userManager.timeToReapply == 0 {
                return
            }
            self.startTime = Date()
            if !self.start {
                self.start.toggle()
            }
            UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
            self.sendNotification(time: userManager.timerCount)
        }) {
            HStack(spacing: buttonVerticalPadding) {
                Image(systemName: "arrow.clockwise")
                    .foregroundColor(.primary)
                Text("Restart")
                    .foregroundColor(.primary)
            }
            .padding(.vertical)
            .frame(width: (UIScreen.main.bounds.width / 2) - buttonHorizontalPadding)
            .background(Capsule().stroke(Color(colourScheme), lineWidth: 2))
            .shadow(color: colourScheme, radius: 2)
        }
        .padding([.top, .bottom], hStackPadding)
    }
    
    // Timer notification logic - sends device notification upon completion
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
