//
//  Weather.swift
//  SunShield
//
//  Created by Matthew Auciello on 19/6/2024.
//

import Foundation

// Weather type
struct Weather: Codable {
    var main: String = "Clear"
}

// Current weather model
struct CurrentWeather: Codable {
    var dt: Int = 0
    var uvi: Double = 0.0
    var weather: [Weather] = [Weather()]
    var temp: Double = 0.0
    var sunrise: Int = 0
    var sunset: Int = 0
    var clouds: Int = 0
    
    var main: String? {
        return weather.first?.main
    }
}

// Hourly weather model
struct HourlyWeather: Codable {
    var dt: Int = 0
    var uvi: Double = 0.0
    var temp: Double = 0.0
    var weather: [Weather] = [Weather()]
    
    var main: String? {
        return weather.first?.main
    }
}


// Daily weather model
struct DailyWeather: Codable {
    var dt: Int = 0
    var uvi: Double = 0.0
    var temp: temp = temp()
    var weather: [Weather] = [Weather()]
    
    var main: String? {
        return weather.first?.main
    }
    
    struct temp: Codable {
        var max: Double = 0.0
    }
}

// Weather response model
struct WeatherResponse: Codable {
    var current: CurrentWeather = CurrentWeather()
    var hourly: [HourlyWeather] = [HourlyWeather()]
    var daily: [DailyWeather] = [DailyWeather()]
}




