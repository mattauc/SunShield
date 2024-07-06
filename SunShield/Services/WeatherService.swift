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
    
    // Calls the proxy server gathers the weather informatin
    func getCurrentWeather(lat: CLLocationDegrees, lon: CLLocationDegrees) -> AnyPublisher<WeatherResponse, Error> {

        let endpoint = WeatherEndpoint.getWeather(latitude: String(lat), longitude: String(lon), exclude: "minutely,alerts", units: "metric")
        do {
            return try apiClient.request(endpoint)
                .map { (response: WeatherResponse) in
                    response
                }
                .eraseToAnyPublisher()
        } catch {
            return Fail(error: error).eraseToAnyPublisher()
        }
    }
}
