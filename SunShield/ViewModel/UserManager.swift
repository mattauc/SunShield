//
//  UserManager.swift
//  SunShield
//
//  Created by Matthew Auciello on 21/6/2024.
//

import Foundation
import Combine

// User defaults - Stores the users SkinType
extension UserDefaults {
    
    // Retrieves and decodes the SkinType
    func getSkinType(forKey key: String) -> SkinType {
        if let jsonData = data(forKey: key),
           let decodedValues = try? JSONDecoder().decode(SkinType.self, from: jsonData) {
            return decodedValues
        } else {
            return SkinType.type1
        }
    }
    
    // Encodes the SkinType
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
        // Retrieves the stored SkinType
        let initialSkinType = UserDefaults.standard.getSkinType(forKey: skinTypeKey)
        self.userProfile = UserProfile(skin: initialSkinType)
    }
    
    // Returns an array of all the SPFTypes
    var spfTypes: [SPFType] {
        return [.fifteen, .thirty, .fifty, .hundred]
    }
    
    // Returns an array of all the SkinTypes
    var skinTypes: [SkinType] {
        return [.type1, .type2, .type3, .type4, .type5, .type6]
    }
    
    // Returns the users SkinType
    var userSkin: SkinType {
        userProfile.skin
    }
    
    // Returns the timerCount
    var timerCount: Int {
        userProfile.timerCount
    }
    
    // Returns the time to reapply sunscreen
    var timeToReapply: Int {
        userProfile.timeUntilReapply
    }
    
    // Stops the sunscreen timer
    func stopSunscreenTimer() {
        timer?.invalidate()
        timer = nil
    }
    
    // Restarts the sunscreen timer
    func restartTimer() {
        timer?.invalidate()
        startSunscreenTimer()
    }
    
    // Updates the sunscreen timer
    private func updateTimer() {
        if userProfile.timerCount > 0 {
            userProfile.updateTimerCount(newCount: userProfile.timerCount - 1)
        } else {
            timer?.invalidate()
            timer = nil
        }
    }
    
    // Starts the susncreen timer
    func startSunscreenTimer() {
        userProfile.timeToReapply()
        if userProfile.timeUntilReapply == 0 {
            return
        }
        timer?.invalidate()
        
        // Creates the timer
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            self?.updateTimer()
        }
    }
    
    // Mark - Intents
    
    // Updates the weather stores on the UserProfile
    func updateWeather(weather: WeatherResponse) {
        userProfile.updateWeatherInfo(weather: weather)
    }
    
    // Updates the user SPF data
    func updateUserSPF(spf: SPFType) {
        userProfile.updateSPF(SPF: spf)
    }
    
    // Updates the user SkinType
    func updateUserSkinType(skin: SkinType) {
        userProfile.updateSkin(type: skin)
        UserDefaults.standard.set(skin, forKey: skinTypeKey)
    }
    
    // Subscribes to the weather data providedby WeatherManager
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
