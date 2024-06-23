//
//  UserManager.swift
//  SunShield
//
//  Created by Matthew Auciello on 21/6/2024.
//

import Foundation
import Combine

class UserManager: ObservableObject {
    @Published private(set) var userProfile: UserProfile
    private var timer: Timer?
    private var timerPaused = false
    
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        self.userProfile = UserProfile()
    }
    
    var spfTypes: [SPFType] {
        return [.fifteen, .thirty, .fifty, .hundred]
    }
    
    var timerCount: Int {
        userProfile.timerCount
    }
    
    var formattedTime: String {
        let hours = timerCount / 3600
        let minutes = (timerCount % 3600) / 60
        let seconds = timerCount % 60
        
        return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
    }
    
    func pauseSunscreenTimer() {
        timerPaused = true
        timer?.invalidate()
    }
    
    func restartTimer() {
        if timerPaused {
            timerPaused = false
        }
        startSunscreenTimer()
    }
    
    private func updateTimer() {
        if userProfile.timerCount > 0 {
            userProfile.updateTimerCount(newCount: userProfile.timerCount - 1)
        } else {
            timer?.invalidate()
            timer = nil
            //Timer finished logic
        }
    }
    
    func startSunscreenTimer() {
        if !timerPaused {
            userProfile.timeToReapply()
        }
        timerPaused = false
        timer?.invalidate()
        
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            self?.updateTimer()
        }
    }
    
    func updateWeather(weather: Weather) {
        userProfile.updateWeatherInfo(weather: weather)
    }
    
    func updateUserSPF(spf: SPFType) {
        userProfile.updateSPF(SPF: spf)
    }
    
    func subscribeToWeatherUpdates(from weatherManager: WeatherManager) {
        
        cancellables.forEach { $0.cancel() }
        cancellables.removeAll()
        
        weatherManager.weatherDataPublisher()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] weather in
                print(weather)
                self?.updateWeather(weather: weather)
            }
            .store(in: &cancellables)
    }
}
