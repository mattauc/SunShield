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
    func setSkin(_ skinType: SkinType, forKey key: String) {
        let data = try? JSONEncoder().encode(skinType)
        set(data, forKey: key)
    }
    
    // Retrieves and decodes the SPFType
    func getSPFType(forKey key: String) -> SPFType {
        if let jsonData = data(forKey: key),
           let decodedValues = try? JSONDecoder().decode(SPFType.self, from: jsonData) {
            return decodedValues
        } else {
            return SPFType.fifteen
        }
    }
    
    // Encodes the SPFType
    func setSpf(_ spfType: SPFType, forKey key: String) {
        let data = try? JSONEncoder().encode(spfType)
        set(data, forKey: key)
    }
    
    // Retrieves and decodes the TemperatureUnit
    func getTemperatureUnit(forKey key: String) -> TemperatureUnit {
        if let jsonData = data(forKey: key),
           let decodedValues = try? JSONDecoder().decode(TemperatureUnit.self, from: jsonData) {
            return decodedValues
        } else {
            return TemperatureUnit.metric
        }
    }
    
    // Encodes the TemperatureUnit
    func setUnit(_ unit: TemperatureUnit, forKey key: String) {
        let data = try? JSONEncoder().encode(unit)
        set(data, forKey: key)
    }
}

class UserManager: ObservableObject {
    
    @Published private(set) var userProfile: UserProfile
    private var timer: Timer?
    private var cancellables = Set<AnyCancellable>()
    private let skinTypeKey = "userSkinType"
    private let spfTypeKey = "userSpfType"
    private let unitKey = "userUnitType"
    
    init() {
        // Retrieves the stored SkinType
        let initialSkinType = UserDefaults.standard.getSkinType(forKey: skinTypeKey)
        let initialSpfType = UserDefaults.standard.getSPFType(forKey: spfTypeKey)
        let initialUnit = UserDefaults.standard.getTemperatureUnit(forKey: unitKey)
        self.userProfile = UserProfile(spf: initialSpfType, skin: initialSkinType, unit: initialUnit)
    }
    
    // Returns an array of all the SPFTypes
    var spfTypes: [SPFType] {
        return [.fifteen, .thirty, .fifty, .hundred]
    }
    
    // Returns an array of all the SkinTypes
    var skinTypes: [SkinType] {
        return [.type1, .type2, .type3, .type4, .type5, .type6]
    }
    
    var unitTypes: [TemperatureUnit] {
        return [.metric, .imperial]
    }
    
    // Returns the users SkinType
    var userSkin: SkinType {
        userProfile.skin
    }
    
    // Returns the users SPF
    var userSpf: SPFType {
        userProfile.SPF
    }
    
    var unitType: TemperatureUnit {
        userProfile.unit
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
    
    // Updates the preferred unit
    func updateTempUnit(unit: TemperatureUnit) {
        userProfile.updateUnit(unit: unit)
        UserDefaults.standard.setUnit(unit, forKey: unitKey)
    }
    
    // Updates the user SPF data
    func updateUserSPF(spf: SPFType) {
        userProfile.updateSPF(SPF: spf)
        UserDefaults.standard.setSpf(spf, forKey: spfTypeKey)
    }
    
    // Updates the user SkinType
    func updateUserSkinType(skin: SkinType) {
        userProfile.updateSkin(type: skin)
        UserDefaults.standard.setSkin(skin, forKey: skinTypeKey)
    }
    
    // Subscribes to the weather data providedby WeatherManager
    func subscribeToWeatherUpdates(from weatherManager: WeatherManager) {
    
        cancellables.forEach { $0.cancel() }
        cancellables.removeAll()
        
        weatherManager.weatherDataPublisher()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] weather in
                self?.updateWeather(weather: weather)
            }
            .store(in: &cancellables)
    }
}
