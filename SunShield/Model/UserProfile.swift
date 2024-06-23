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
}

struct UserProfile {
    
    private(set) var SPF = SPFType.thirty
    private(set) var skin = SkinType.type3
    private(set) var weatherInfo: Weather?
    private(set) var timerCount: Int = 0
  
    mutating func updateSPF(SPF: SPFType) {
        print(SPF.id)
        self.SPF = SPF
    }

    mutating func updateWeatherInfo(weather: Weather) {
        self.weatherInfo = weather
    }
    
    mutating func timeToReapply() {
        let timeToReapply = 5400
        timerCount = timeToReapply
    }
    
    mutating func updateTimerCount(newCount: Int) {
        self.timerCount = newCount
    }
}
