//
//  NetworkManager.swift
//  SunShield
//
//  Created by Matthew Auciello on 19/6/2024.
//

import Foundation
import Combine

protocol APIEndpoint {
    var baseURL: URL { get } 
    var path: String { get }
    var method: HTTPMethod { get }
    var headers: [String: String]? { get }
    var parameters: [String: String] { get }
}

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case patch = "PATCH"
    case delete = "DELETE"
}

enum APIError: Error {
    case invalidResponse
    case invalidData
    case invalidURL
}

enum WeatherEndpoint: APIEndpoint {
    case getWeather(latitude: String, longitude: String, exclude: String, units: String)
    
    var baseURL: URL {
        return URL(string: "https://sunshield.mattauc.com")!
    }
    
    var path: String {
        switch self {
        case .getWeather:
            return "/api/weather"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .getWeather:
            return .post
        }
    }
    
    var headers: [String: String]? {
        switch self {
        case .getWeather:
            return ["Authorization": "Default"]
        }
    }
    
    var parameters: [String: String] {
        switch self {
        case .getWeather(let latitude, let longitude, let exclude, let units):
            return ["lat": latitude, "lon": longitude, "exclude": exclude, "units": units]
        }
    }
}

protocol APIClient {
    associatedtype EndpointType: APIEndpoint
    func request<T: Decodable>(_ endpoint: EndpointType) throws -> AnyPublisher<T, Error>
}

class URLSessionAPIClient<EndpointType: APIEndpoint>: APIClient {
    
    func request<T: Decodable>(_ endpoint: EndpointType) throws -> AnyPublisher<T, Error> {
        
        //Creates endpoint baseURL + path
        let url = endpoint.baseURL.appendingPathComponent(endpoint.path)
        
        //Adds parameters
        var components = URLComponents(url: url, resolvingAgainstBaseURL: true)!
        components.queryItems = endpoint.parameters.map { URLQueryItem(name: $0.key, value: $0.value) }
        
        guard let finalURL = components.url else {
           throw APIError.invalidURL
       }
        
        //Determines what type of request
        var request = URLRequest(url: finalURL)
        request.httpMethod = endpoint.method.rawValue
        
        print(finalURL)
        return URLSession.shared.dataTaskPublisher(for: request)
            .subscribe(on: DispatchQueue.global(qos: .background))
            .tryMap { data, response -> Data in
                guard let httpResponse = response as? HTTPURLResponse,
                      (200...299).contains(httpResponse.statusCode) else {
                    throw APIError.invalidResponse
                }
                return data
            }
            .decode(type: T.self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }
}
