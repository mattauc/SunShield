//
//  WeatherService.swift
//  SunShield
//
//  Created by Matthew Auciello on 19/6/2024.
//

import Foundation
import CoreLocation

class WeatherService {
    
    enum WeatherEndpoint: APIEndpoint {
        
        
        case getWeather
        
        var baseURL: URL {
            return URL(string: "https://example.com/api")!
        }
        
        var path: String {
            switch self {
            case .getWeather:
                return "/users"
            }
        }
        
        var method: HTTPMethod {
            switch self {
            case .getWeather:
                return .get
            }
        }
        
        var headers: [String: String]? {
            switch self {
            case .getWeather:
                return ["Authorization": "Bearer TOKEN"]
            }
        }
        
        var parameters: [String: Any]? {
            switch self {
            case .getWeather:
                return ["page": 1, "limit": 10]
            }
        }
    }
    
    func getCurrentWeather(lat: CLLocationDegrees, lon: CLLocationDegrees) async throws -> ResponseBody {
        
    }
}

struct ResponseBody: Decodable {
    
}
