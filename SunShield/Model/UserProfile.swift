//
//  UserProfile.swift
//  SunShield
//
//  Created by Matthew Auciello on 19/6/2024.
//

import Foundation

enum SPFType {
    case fifteen
    case thirty
    case fifty
    case hundred
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
  
    mutating func updateSPF(SPF: SPFType) {
        self.SPF = SPF
    }

    mutating func updateWeatherInfo(weather: Weather) {
        //print(weather)
        self.weatherInfo = weather
    }
    
    func checkValue() {
        if self.SPF == SPFType.fifty {
            if let weather = weatherInfo {
                print("FIFTY + \(weather.uvi) = PROTECTED")
            }
        } else {
            if let weather = weatherInfo {
                print("SAD + \(weather.temp) = DIE")
            }
        }
    }
    
//    func UVSunscreenInteraction() -> Date {
//        
//        
//        return
//    }
}
