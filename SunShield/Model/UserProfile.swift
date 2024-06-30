//
//  UserProfile.swift
//  SunShield
//
//  Created by Matthew Auciello on 19/6/2024.
//

import Foundation

enum SPFType: Identifiable, Codable {
  
    case fifteen
    case thirty
    case fifty
    case hundred
    
    var id: String {
        switch self {
        case .fifteen:
            return "15"
        case .thirty:
            return "30"
        case .fifty:
            return "50"
        case .hundred:
            return "100"
        }
    }
    
    //SPFW for various (SPF) levels
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
    
    //Time to skin Burn at UV Index = 1 (minutes)
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
}

struct UserProfile: Codable {
    
    private(set) var SPF = SPFType.fifteen
    private(set) var skin = SkinType.type3
    private(set) var weatherInfo: WeatherResponse?
    private(set) var timerCount: Int = 0
    private(set) var timeUntilReapply = 0
    
    mutating func updateSPF(SPF: SPFType) {
        self.SPF = SPF
    }
    
    mutating func updateSkin(type: SkinType) {
        print(type.rawValue)
        self.skin = type
    }
    
    mutating func updateWeatherInfo(weather: WeatherResponse) {
        self.weatherInfo = weather
    }
    
    //Reference study
    mutating func timeToReapply() {
        guard let weatherInfo = weatherInfo else {
            timerCount = 0
            timeUntilReapply = 0
            return
        }
        
        let uvIndex = weatherInfo.current.uvi
        let timeToSkinBurn = skin.timeToSkinBurn
        let sunProtectionFactorWeight = SPF.sunProtectionFactorWeight
        
        if uvIndex < 1 {
            timerCount = 0
            timeUntilReapply = 0
            return
        }
        
        
        let timeToReapply = ((timeToSkinBurn / uvIndex ) * sunProtectionFactorWeight) * 60
        self.timerCount = Int(timeToReapply)
        self.timeUntilReapply = Int(timeToReapply)
    }
    
    mutating func updateTimerCount(newCount: Int) {
        self.timerCount = newCount
    }
}
