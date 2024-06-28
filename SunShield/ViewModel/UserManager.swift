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
    
    var timeToReapply: Int {
        userProfile.timeUntilReapply
    }
    
    func stopSunscreenTimer() {
        timer?.invalidate()
        timer = nil
    }
    
    func restartTimer() {
        timer?.invalidate()
        startSunscreenTimer()
    }
    
    private func updateTimer() {
        if userProfile.timerCount > 0 {
            userProfile.updateTimerCount(newCount: userProfile.timerCount - 1)
        } else {
            timer?.invalidate()
            timer = nil
        }
    }
    
    func startSunscreenTimer() {
        userProfile.timeToReapply()
        timer?.invalidate()
        
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            self?.updateTimer()
        }
    }
    
    func updateWeather(weather: WeatherResponse) {
        userProfile.updateWeatherInfo(weather: weather)
    }
    
    func updateUserSPF(spf: SPFType) {
        userProfile.updateSPF(SPF: spf)
    }
    
    func updateUserSkinType(skin: SkinType) {
        userProfile.updateSkin(type: skin)
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
