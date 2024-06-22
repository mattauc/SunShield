//
//  SunShieldApp.swift
//  SunShield
//
//  Created by Matthew Auciello on 19/6/2024.
//

import SwiftUI

@main
struct SunShieldApp: App {
    @StateObject var userManager = UserManager()
    @StateObject var weatherManager = WeatherManager(deviceLocationService: DeviceLocationService.shared)
    
    var body: some Scene {
        WindowGroup {
            SunShieldInterface()
                .environmentObject(userManager)
                .environmentObject(weatherManager)
        }
    }
}
