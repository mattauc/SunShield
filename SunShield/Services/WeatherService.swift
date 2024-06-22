//
//  WeatherService.swift
//  SunShield
//
//  Created by Matthew Auciello on 19/6/2024.
//

import Foundation
import CoreLocation
import Combine

class WeatherService {
    
    private let apiClient = URLSessionAPIClient<WeatherEndpoint>()
    static let shared = WeatherService()
    
    func getCurrentWeather(lat: CLLocationDegrees, lon: CLLocationDegrees) -> AnyPublisher<Weather, Error> {

        let endpoint = WeatherEndpoint.getWeather(latitude: String(lat), longitude: String(lon), exclude: "hourly,minutely,daily,alerts", units: "metric")
        do {
            return try apiClient.request(endpoint)
                .map { (response: WeatherResponse) in
                    response.current
                }
                .eraseToAnyPublisher()
        } catch {
            return Fail(error: error).eraseToAnyPublisher()
        }
    }
}

struct WeatherResponse: Codable {
    let current: Weather
}
