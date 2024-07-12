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
    @EnvironmentObject var weatherManager: WeatherManager
    @Binding var startTime: Date?
    @State var start: Bool = false
    @State var canPress: Bool = false
    
    
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
                Image(systemName: self.canPress ? (self.start ? "stop.fill" : "play.fill") : "exclamationmark.octagon.fill")
                    .foregroundColor(.primary)
                Text(self.canPress ? (self.start ? "Stop" : "Start") : "LOW UV")
                    .foregroundColor(.primary)
            }

            .padding(.vertical)
            .frame(width: (UIScreen.main.bounds.width / 2) - buttonHorizontalPadding)
            .background(self.canPress ? colourScheme : Color.gray)
            .clipShape(Capsule())
            .shadow(color: self.canPress ? colourScheme : Color.gray, radius: 2)
        }
        .onChange(of: weatherManager.unformattedUV) {
            if weatherManager.unformattedUV > 1.0 {
                canPress = true
            }
        }
        .padding([.top, .bottom], hStackPadding)
        .disabled(!canPress)
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
                Image(systemName: self.canPress ? "arrow.clockwise" : "exclamationmark.octagon.fill")
                    .foregroundColor(.primary)
                Text(self.canPress ? "Restart" : "LOW UV")
                    .foregroundColor(.primary)
            }
            .padding(.vertical)
            .frame(width: (UIScreen.main.bounds.width / 2) - buttonHorizontalPadding)
            .background(Capsule().stroke(self.canPress ? colourScheme : Color.gray))
            .shadow(color: self.canPress ? colourScheme : Color.gray, radius: 2)
        }
        .onChange(of: weatherManager.unformattedUV) {
            if weatherManager.unformattedUV > 1.0 {
                canPress = true
            }
        }
        .padding([.top, .bottom], hStackPadding)
        .disabled(!canPress)
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
