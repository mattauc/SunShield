//
//  SunShieldUITests.swift
//  SunShieldUITests
//
//  Created by Matthew Auciello on 3/7/2024.
//

import XCTest

final class SunShieldUITests: XCTestCase {
    
    var app: XCUIApplication!

    override func setUpWithError() throws {
        continueAfterFailure = false
        app = XCUIApplication()
    }
    
    func testCannotMoveUnlessSkinSelected() throws {
        app.launchArguments += ["-isWelcomeScreenOver", "NO"]
        app.launch()
        
        let startButton = app.buttons["Let's Get Started"]
        XCTAssertTrue(startButton.exists)
        startButton.tap()
        
        let skinButton = app.windows.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element
        XCTAssertTrue(skinButton.exists)
        skinButton.tap()
        startButton.tap()
    }
    
    func testUserCanSelectSPF() throws {
        app.launchArguments += ["-isWelcomeScreenOver", "YES"]
        app.launch()
        
        let elementsQuery = XCUIApplication().scrollViews.otherElements.scrollViews.otherElements.scrollViews.otherElements
        elementsQuery.staticTexts["15"].swipeLeft()
        XCTAssertTrue(elementsQuery.staticTexts["30"].exists)
        elementsQuery.staticTexts["30"].tap()
        elementsQuery.staticTexts["30"].swipeLeft()
        elementsQuery.staticTexts["50"].swipeLeft()
        XCTAssertTrue(elementsQuery.staticTexts["100"].exists)
        elementsQuery.staticTexts["100"].tap()
    }
    
    func testUVIndexInformationPage() throws {
        app.launchArguments += ["-isWelcomeScreenOver", "YES"]
        app.launch()
        
        let scrollViewsQuery = app.scrollViews
        let infoButton = scrollViewsQuery.otherElements.scrollViews.otherElements.buttons["Info"]
        XCTAssertTrue(infoButton.exists)
        infoButton.tap()
        
        let element = scrollViewsQuery.otherElements.containing(.staticText, identifier:"0-2").element
        element.swipeUp()
        element.swipeUp()
        let backButton = app.navigationBars["_TtGC7SwiftUI32NavigationStackHosting"].buttons["Back"]
        XCTAssertTrue(backButton.exists)
        backButton.tap()
    }
    
    func testNavigateToSettings() throws {
        app.launchArguments += ["-isWelcomeScreenOver", "YES"]
        app.launch()
        
        let settingsButton = app.navigationBars["_TtGC7SwiftUI32NavigationStackHosting"].buttons["gearshape"]
        XCTAssertTrue(settingsButton.exists)
        settingsButton.tap()
        
        let collectionViewsQuery = app.collectionViews
        XCTAssertTrue(collectionViewsQuery/*@START_MENU_TOKEN@*/.buttons["📘 Skin Types"]/*[[".cells.buttons[\"📘 Skin Types\"]",".buttons[\"📘 Skin Types\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.exists)
        collectionViewsQuery/*@START_MENU_TOKEN@*/.buttons["📘 Skin Types"]/*[[".cells.buttons[\"📘 Skin Types\"]",".buttons[\"📘 Skin Types\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        
        let backButton = app.navigationBars["_TtGC7SwiftUI32NavigationStackHosting"].buttons["Back"]
        XCTAssertTrue(backButton.exists)
        backButton.tap()
        
        XCTAssertTrue(collectionViewsQuery/*@START_MENU_TOKEN@*/.buttons["☀️ UV Index"]/*[[".cells.buttons[\"☀️ UV Index\"]",".buttons[\"☀️ UV Index\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.exists)
        collectionViewsQuery/*@START_MENU_TOKEN@*/.buttons["☀️ UV Index"]/*[[".cells.buttons[\"☀️ UV Index\"]",".buttons[\"☀️ UV Index\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        
        backButton.tap()
        
        XCTAssertTrue(collectionViewsQuery/*@START_MENU_TOKEN@*/.buttons["IV"]/*[[".cells",".segmentedControls.buttons[\"IV\"]",".buttons[\"IV\"]"],[[[-1,2],[-1,1],[-1,0,1]],[[-1,2],[-1,1]]],[0]]@END_MENU_TOKEN@*/.exists)
        collectionViewsQuery/*@START_MENU_TOKEN@*/.buttons["IV"]/*[[".cells",".segmentedControls.buttons[\"IV\"]",".buttons[\"IV\"]"],[[[-1,2],[-1,1],[-1,0,1]],[[-1,2],[-1,1]]],[0]]@END_MENU_TOKEN@*/.tap()
        backButton.tap()
    }
    
    func testUserCanUseTimer() throws {
        app.launchArguments += ["-isWelcomeScreenOver", "YES"]
        app.launch()
        
        let elementsQuery = XCUIApplication().scrollViews.otherElements.scrollViews.otherElements
        
        XCTAssertTrue(elementsQuery.buttons["Start"].exists)
        elementsQuery.buttons["Start"].tap()
        
        XCTAssertTrue(elementsQuery/*@START_MENU_TOKEN@*/.staticTexts["Restart"]/*[[".buttons[\"Restart\"].staticTexts[\"Restart\"]",".staticTexts[\"Restart\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.exists)
        elementsQuery/*@START_MENU_TOKEN@*/.staticTexts["Restart"]/*[[".buttons[\"Restart\"].staticTexts[\"Restart\"]",".staticTexts[\"Restart\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        
    }
    
    func testLaunchPerformance() throws {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 7.0, *) {
            // This measures how long it takes to launch your application.
            measure(metrics: [XCTApplicationLaunchMetric()]) {
                XCUIApplication().launch()
            }
        }
    }
}
