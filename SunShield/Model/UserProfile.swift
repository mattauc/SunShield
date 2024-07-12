//
//  UserProfile.swift
//  SunShield
//
//  Created by Matthew Auciello on 19/6/2024.
//

import Foundation

// SPF Type information
enum SPFType: String, Identifiable, CaseIterable, Codable {
    case fifteen = "15"
    case thirty = "30"
    case fifty = "50"
    case hundred = "100"
    
    var id: String {
        rawValue
    }
    
    // SPFW for various (SPF) levels
    var sunProtectionFactorWeight: Double {
        switch self {
        case .fifteen:
            return 3.7
        case .thirty:
            return 7.5
        case .fifty:
            return 12.4
        case .hundred:
            return 13.7
        }
    }
}

// Skin type information
enum SkinType: String, Codable {
    case type1 = "I"
    case type2 = "II"
    case type3 = "III"
    case type4 = "IV"
    case type5 = "V"
    case type6 = "VI"
    
    var stringValue: String {
        return self.rawValue
    }
    
    // Time to skin Burn at UV Index = 1 (minutes)
    var timeToSkinBurn: Double {
        switch self {
        case .type1:
            return 67.0
        case .type2:
            return 100.0
        case .type3:
            return 200.0
        case .type4:
            return 300.0
        case .type5:
            return 400.0
        case .type6:
            return 500.0
        }
    }
    
    // Relative colour information
    var Colour: RGBA {
        switch self {
        case .type1:
            return RGBA(red: 255/255, green: 206/255, blue: 180/255, alpha: 1.0) // Pale white skin
        case .type2:
            return RGBA(red: 240/255, green: 184/255, blue: 160/255, alpha: 1.0) // Fair skin
        case .type3:
            return RGBA(red: 195/255, green: 149/255, blue: 130/255, alpha: 1.0) // Darker white skin
        case .type4:
            return RGBA(red: 165/255, green: 126/255, blue: 110/255, alpha: 1.0) // Light brown skin
        case .type5:
            return RGBA(red: 120/255, green: 92/255, blue: 80/255, alpha: 1.0) // Brown skin
        case .type6:
            return RGBA(red: 75/255, green: 57/255, blue: 50/255, alpha: 1.0) // Dark brown or black skin
        }
    }
}

// User model
struct UserProfile: Codable {
    
    private(set) var SPF = SPFType.fifteen
    private(set) var skin = SkinType.type3
    private(set) var weatherInfo: WeatherResponse?
    private(set) var timerCount: Int = 0
    private(set) var timeUntilReapply = 0
    
    init(spf: SPFType, skin: SkinType) {
        self.SPF = spf
        self.skin = skin
    }
    
    // Updates the user SPF type
    mutating func updateSPF(SPF: SPFType) {
        self.SPF = SPF
    }
    
    // Updates the user skin type
    mutating func updateSkin(type: SkinType) {
        self.skin = type
    }
    
    // Updates the weather info to reflect current weather
    mutating func updateWeatherInfo(weather: WeatherResponse) {
        self.weatherInfo = weather
    }
    
    // Calculations applied to return the time until reapplication
    mutating func timeToReapply() {
        guard let weatherInfo = weatherInfo else {
            timerCount = 0
            timeUntilReapply = 0
            return
        }
        
        var uvIndex = weatherInfo.getMax24HourUV()
        let timeToSkinBurn = skin.timeToSkinBurn
        let sunProtectionFactorWeight = SPF.sunProtectionFactorWeight
        
        if uvIndex < 1 {
            uvIndex = 1.0
        }
        
        let timeToReapply = ((timeToSkinBurn / uvIndex ) * sunProtectionFactorWeight) * 60
        self.timerCount = Int(timeToReapply)
        self.timeUntilReapply = Int(timeToReapply)
    }
    
    // Updates the timer count
    mutating func updateTimerCount(newCount: Int) {
        self.timerCount = newCount
    }
}
