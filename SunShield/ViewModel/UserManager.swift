//
//  UserManager.swift
//  SunShield
//
//  Created by Matthew Auciello on 21/6/2024.
//

import Foundation
import Combine

extension UserDefaults {
    func getSkinType(forKey key: String) -> SkinType {
        if let jsonData = data(forKey: key),
           let decodedValues = try? JSONDecoder().decode(SkinType.self, from: jsonData) {
            return decodedValues
        } else {
            return SkinType.type1
        }
    }
    
    func set(_ skinType: SkinType, forKey key: String) {
        let data = try? JSONEncoder().encode(skinType)
        set(data, forKey: key)
    }
}

class UserManager: ObservableObject {
    @Published private(set) var userProfile: UserProfile
    private var timer: Timer?
    private var cancellables = Set<AnyCancellable>()
    private let skinTypeKey = "userSkinType"
    
    init() {
        let initialSkinType = UserDefaults.standard.getSkinType(forKey: skinTypeKey)
        self.userProfile = UserProfile(skin: initialSkinType)
        
    }
    
    var spfTypes: [SPFType] {
        return [.fifteen, .thirty, .fifty, .hundred]
    }
    
    var skinTypes: [SkinType] {
        return [.type1, .type2, .type3, .type4, .type5, .type6]
    }
    
    var userSkin: SkinType {
        userProfile.skin
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
        if userProfile.timeUntilReapply == 0 {
            return
        }
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
        UserDefaults.standard.set(skin, forKey: skinTypeKey)
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
