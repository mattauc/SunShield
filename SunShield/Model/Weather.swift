//
//  Weather.swift
//  SunShield
//
//  Created by Matthew Auciello on 19/6/2024.
//

import Foundation

struct Weather: Codable {
    var temp = 0.0
    var uvi = 0.0
    var clouds = 0
}


//struct SunShield {
//    private(set) var weatherInfo: Weather
//    
//    init(initialWeather: Weather) {
//        self.weatherInfo = initialWeather
//    }
//    
//    mutating func updateWeatherInfo(weather: Weather) {
//        print(weather)
//        self.weatherInfo = weather
//    }
//}


