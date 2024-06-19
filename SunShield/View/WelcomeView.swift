//
//  WelcomeView.swift
//  SunShield
//
//  Created by Matthew Auciello on 19/6/2024.
//

import SwiftUI
import CoreLocationUI

struct WelcomeView: View {
    
    
    @AppStorage("isWelcomeScreenOver") var isWelcomeScreenOver = false
    @State var isPressed: Bool = false
    
    var body: some View {
        NavigationStack {
            VStack {
                
                
                Button("Next") {
                    isPressed = true
                    isWelcomeScreenOver = true
                }
            }
            .navigationDestination(isPresented: $isPressed) {
                SunShieldInterface().navigationBarHidden(true)
            }
            //Have it so on tap of the share location button, user sets their location.
            //Have a settings button that user needs to input and shift through
        }
    }
}

#Preview {
    WelcomeView()
}
