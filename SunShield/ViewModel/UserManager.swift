//
//  UserManager.swift
//  SunShield
//
//  Created by Matthew Auciello on 21/6/2024.
//

import Foundation
import Combine

class UserManager: ObservableObject {
    @Published private(set) var userProfile: UserProfile
    
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        self.userProfile = UserProfile()
    }
    
    func updateWeather(weather: Weather) {
        userProfile.updateWeatherInfo(weather: weather)
    }
    
    func updateUserSPF() {
        print("UPDATING SPF")
        userProfile.updateSPF(SPF: SPFType.fifty)
    }
    
    func checkSunSafe() {
        print("CHECKING SUN SAFE")
        userProfile.checkValue()
    }
    
    func subscribeToWeatherUpdates(from weatherManager: WeatherManager) {
        
        cancellables.forEach { $0.cancel() }
        cancellables.removeAll()
        
        weatherManager.weatherDataPublisher()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] weather in
                print(weather)
                self?.updateWeather(weather: weather)
            }
            .store(in: &cancellables)
    }
}
