//
//  UserProfile.swift
//  SunShield
//
//  Created by Matthew Auciello on 19/6/2024.
//

import Foundation

enum SPFType: Identifiable {
  
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
}

enum SkinType {
    case type1
    case type2
    case type3
    case type4
    case type5
    case type6
    
    var stringValue: String {
        switch self {
        case .type1:
            return "I"
        case .type2:
            return "II"
        case .type3:
            return "III"
        case .type4:
            return "IV"
        case .type5:
            return "V"
        case .type6:
            return "VI"
        }
    }
}

struct UserProfile {
    
    private(set) var SPF = SPFType.thirty
    private(set) var skin = SkinType.type3
    private(set) var weatherInfo: WeatherResponse?
    private(set) var timerCount: Int = 0
    private(set) var timeUntilReapply = 0
  
    mutating func updateSPF(SPF: SPFType) {
        self.SPF = SPF
    }
    
    mutating func updateSkin(type: SkinType) {
        self.skin = type
    }

    mutating func updateWeatherInfo(weather: WeatherResponse) {
        self.weatherInfo = weather
    }
    
    mutating func timeToReapply() {
        let timeToReapply = 600
        timerCount = timeToReapply
        timeUntilReapply = timeToReapply
    }
    
    mutating func updateTimerCount(newCount: Int) {
        self.timerCount = newCount
    }
}
