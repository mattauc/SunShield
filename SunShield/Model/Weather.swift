//
//  Weather.swift
//  SunShield
//
//  Created by Matthew Auciello on 19/6/2024.
//

import Foundation

struct Weather: Codable {
    var main: String = "Clear"
}

struct CurrentWeather: Codable {
    var dt: Int = 0
    var uvi: Double = 0.0
    var weather: [Weather] = [Weather()]
    var temp: Double = 0.0
    
    var main: String? {
        return weather.first?.main
    }
}

struct HourlyWeather: Codable {
    var dt: Int = 0
    var uvi: Double = 0.0
    var temp: Double = 0.0
    var weather: [Weather] = [Weather()]
    
    var main: String? {
        return weather.first?.main
    }
}


struct WeatherResponse: Codable {
    var current: CurrentWeather = CurrentWeather()
    var hourly: [HourlyWeather] = [HourlyWeather()]
}



