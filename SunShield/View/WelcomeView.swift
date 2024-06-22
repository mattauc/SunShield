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
    @EnvironmentObject var userManager: UserManager
    
    var body: some View {
        NavigationStack {
            VStack {
                
                nextButton
            }
            .navigationDestination(isPresented: $isPressed) {
                SunShieldInterface().navigationBarHidden(true)
            }
         
        }
    }
    
    var nextButton: some View {
        Button(action: {
            isPressed = true
            isWelcomeScreenOver = true
        }) {
            Image(systemName: "arrow.right")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 30, height: 30)
                .foregroundColor(.blue)
        }
        .buttonStyle(PlainButtonStyle())
    }
    
    var SPFOptions: some View {
        //SPF 15, 30, 50, 100
        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 20) {
        }
    }
}

#Preview {
    WelcomeView()
}
