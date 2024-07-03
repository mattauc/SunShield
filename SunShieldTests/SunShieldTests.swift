//
//  SunShieldTests.swift
//  SunShieldTests
//
//  Created by Matthew Auciello on 3/7/2024.
//

import XCTest
@testable import SunShield

final class SunShieldTests: XCTestCase {
    var userProfile: UserProfile!
    var weatherProfile: WeatherResponse!
    
    override func setUpWithError() throws {
        weatherProfile = WeatherResponse()
        userProfile = UserProfile()
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testUpdateSpfType() throws {
        userProfile.updateSPF(SPF: SPFType.hundred)
        XCTAssertTrue(userProfile.SPF == SPFType.hundred)
    }
    
    func testUpdateSkinType() throws {
        userProfile.updateSkin(type: SkinType.type5)
        XCTAssertTrue(userProfile.skin == SkinType.type5)
    }
    
    func testGetTimeToReapplicationOne() throws {
        weatherProfile.current.uvi = 10.0
        userProfile.updateWeatherInfo(weather: weatherProfile)
        userProfile.updateSPF(SPF: SPFType.fifteen)
        userProfile.updateSkin(type: SkinType.type2)
        
        userProfile.timeToReapply()
        XCTAssertTrue(userProfile.timeUntilReapply == 2220)
    }
    
    func testGetTimeToReapplicationTwo() throws {
        weatherProfile.current.uvi = 4.0
        userProfile.updateWeatherInfo(weather: weatherProfile)
        userProfile.updateSPF(SPF: SPFType.fifty)
        userProfile.updateSkin(type: SkinType.type1)
        
        userProfile.timeToReapply()
        XCTAssertTrue(userProfile.timeUntilReapply == 12462)
    }
    
    func testGetTimeToReapplicationThree() throws {
        weatherProfile.current.uvi = 1.0
        userProfile.updateWeatherInfo(weather: weatherProfile)
        userProfile.updateSPF(SPF: SPFType.thirty)
        userProfile.updateSkin(type: SkinType.type5)
        
        userProfile.timeToReapply()
        XCTAssertTrue(userProfile.timeUntilReapply == 180000)
    }
    
    

//    func testPerformanceExample() throws {
//        // This is an example of a performance test case.
//        measure {
//            // Put the code you want to measure the time of here.
//        }
//    }

}
