//
//  WeatherManagerTests.swift
//  SunShieldTests
//
//  Created by Matthew Auciello on 7/7/2024.
//

import XCTest
import Combine
@testable import SunShield
import CoreLocation

final class WeatherManagerTests: XCTestCase {
    
    var sut: WeatherManager!
    var mockWeatherService: MockWeatherService!
    
    override func setUpWithError() throws {
        mockWeatherService = MockWeatherService()
        sut = WeatherManager(deviceLocationService: DeviceLocationService.shared, weatherService: mockWeatherService)
    }
        
    override func tearDownWithError() throws {
        sut = nil
        mockWeatherService = nil
        super.tearDown()
    }

    func testFetchWeather() {
        // Given
        let expectation = XCTestExpectation(description: "Fetch weather data")
        
        let mockCurrentWeather = CurrentWeather(
            dt: 1625689200,
            uvi: 8.5,
            weather: [Weather(main: "Clear")],
            temp: 28.5,
            sunrise: 1625677800,
            sunset: 1625721600,
            clouds: 10
        )
        
        // Mock hourly weather
        let mockHourlyWeather = HourlyWeather(
            dt: 1625692800,
            uvi: 7.5,
            temp: 30.0,
            weather: [Weather(main: "Clouds")]
        )
        
        // Mock daily weather
        let mockDailyWeather = DailyWeather(
            dt: 1625692800,
            uvi: 8.0,
            temp: DailyWeather.temp(max: 32.0),
            weather: [Weather(main: "Rain")]
        )
        
        // Mock weather response
        let expectedWeather = WeatherResponse(
            current: mockCurrentWeather,
            hourly: [mockHourlyWeather],
            daily: [mockDailyWeather]
        )
        
        // When
        sut.fetchWeather()
        
        // Then
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            XCTAssertEqual(self.sut.weatherData, expectedWeather, "Weather data should be updated correctly")
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 5)
    }
    
    func testLocationUpdate() {
        
    }
    
    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
}

class MockWeatherService: WeatherService {
    
    override func getCurrentWeather(lat: CLLocationDegrees, lon: CLLocationDegrees) -> AnyPublisher<WeatherResponse, Error> {
        let mockCurrentWeather = CurrentWeather(
            dt: 1625689200,
            uvi: 8.5,
            weather: [Weather(main: "Clear")],
            temp: 28.5,
            sunrise: 1625677800,
            sunset: 1625721600,
            clouds: 10
        )
        
        // Mock hourly weather
        let mockHourlyWeather = HourlyWeather(
            dt: 1625692800,
            uvi: 7.5,
            temp: 30.0,
            weather: [Weather(main: "Clouds")]
        )
        
        // Mock daily weather
        let mockDailyWeather = DailyWeather(
            dt: 1625692800,
            uvi: 8.0,
            temp: DailyWeather.temp(max: 32.0),
            weather: [Weather(main: "Rain")]
        )
        
        // Mock weather response
        let mockWeatherResponse = WeatherResponse(
            current: mockCurrentWeather,
            hourly: [mockHourlyWeather],
            daily: [mockDailyWeather]
        )
        return Just(mockWeatherResponse)
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
}
