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
    @State var canPress: Bool = false
    @EnvironmentObject var userManager: UserManager
    var buttonColour = Color(red: 1.0, green: 0.4, blue: 0.2)
    @State private var selectedType: String?
    @State var skinInfo: Bool = false
    
    private let welcomeFontSize: CGFloat = 32
    private let skinInfoHorizontalPadding: CGFloat = 150
    private let infoIconOffset: CGFloat = -55
    private let infoIconOffsetY: CGFloat = 13
    private let skinButtonPadding: CGFloat = 20
    
    var body: some View {
        if isPressed {
            SunShieldInterface()
        } else {
            ZStack {
                sunWallpaper
                VStack {
                    Text("Welcome!")
                        .font(.system(size: welcomeFontSize, weight: .bold, design: .default))
                        .padding([.bottom, .top], 8)
                        .foregroundColor(Color.primary)
                    
                    Text("Never forget your sun protection again with SunShield, your personalized sunscreen reminder.")
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 130)
                        .foregroundColor(Color.primary)
                        .padding(.bottom, 40)
                    skinTypeSelection
                    nextButton
                        .padding()
                }
                .offset(y: 130)
            }
        }
    }
    
    var sunWallpaper: some View {
        ZStack {
            Color.clear.edgesIgnoringSafeArea(.all)
            Circle()
                .fill(RadialGradient(gradient: Gradient(colors: [Color(red: 1.0, green: 0.8, blue: 0.3), Color(red: 1.0, green: 0.6, blue: 0.4), Color(red: 1.0, green: 0.4, blue: 0.2)]), center: .topLeading, startRadius: 0, endRadius: 600))
                .frame(width: 650)
                .offset(y:-400)
            
            Circle()
                .fill(Color.white.opacity(0.5))
                .frame(width: 200)
                .offset(x: 200, y: -320)
            
            Circle()
                .fill(Color.white.opacity(0.5))
                .frame(width: 300)
                .offset(x: -250, y: -400)
            
            Circle()
                .fill(Color.white.opacity(0.5))
                .frame(width: 100)
                .offset(x: -100, y: -200)
        }
    }
    
    var skinTypeSelection: some View {
        VStack {
            if skinInfo {
                skinInfoOverlay
                    .padding(.horizontal, skinInfoHorizontalPadding)
            }
            HStack {
                Group {
                    Text("Select Your Skin Type")
                        .font(.title3)
                        .bold()
                    
                    Button {
                        withAnimation {
                            skinInfo.toggle()
                        }
                    } label: {
                        Image(systemName: "info.circle")
                            .foregroundColor(buttonColour)
                    }
                    
                    
                    .font(.title2)
                }
                .offset(x: infoIconOffset,  y: infoIconOffsetY)
            }
            .padding(.bottom)
            skinButtons
            
        }

    }
    
    var skinInfoOverlay: some View {
        GroupBox {
            VStack(alignment: .leading, spacing: 16) {
                Link("Skin Type Information", destination: URL(string: "https://www.fda.gov/radiation-emitting-products/tanning/your-skin")!)
                    .font(.title)
                    .bold()
                    .padding(.bottom, 16)
                    .foregroundColor(.red)
                infoTextValues
                HStack {
                    Spacer()
                    Button {
                        withAnimation {
                            skinInfo.toggle()
                        }
                    } label: {
                        Text("Dismiss")
                            .padding()
                            .background(Color.red)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                    }
                    .padding(.top, 16)
                    Spacer()
                }
            }
            .cornerRadius(10)
            .shadow(radius: 10)
        }
        .groupBoxStyle(.custom)
    }
    
    var infoTextValues: some View {
        VStack(alignment: .leading, spacing: 12) {
            Group {
                HStack {
                    Text("Type I:")
                        .font(.headline)
                        .bold()
                    Text("Always burns")
                        .font(.subheadline)
                }
                HStack {
                    Text("Type II:")
                        .font(.headline)
                        .bold()
                    Text("Burns easily")
                        .font(.subheadline)
                }
                HStack {
                    Text("Type III:")
                        .font(.headline)
                        .bold()
                    Text("Burns moderately")
                        .font(.subheadline)
                }
                HStack {
                    Text("Type IV:")
                        .font(.headline)
                        .bold()
                    Text("Burns minimally")
                        .font(.subheadline)
                }
                HStack {
                    Text("Type V:")
                        .font(.headline)
                        .bold()
                    Text("Rarely burns")
                        .font(.subheadline)
                }
                HStack {
                    Text("Type VI:")
                        .font(.headline)
                        .bold()
                    Text("Never burns")
                        .font(.subheadline)
                }
            }
        }
    }

    var skinButtons: some View {
        VStack {
            HStack(spacing: skinButtonPadding) {
                skinButton(type: SkinType.type1, buttonColour: Color(rgba: SkinType.type1.Colour))
                skinButton(type: SkinType.type2, buttonColour: Color(rgba: SkinType.type2.Colour))
                skinButton(type: SkinType.type3, buttonColour: Color(rgba: SkinType.type3.Colour))
            }
            .padding()
            HStack(spacing: skinButtonPadding) {
                skinButton(type: SkinType.type4, buttonColour: Color(rgba: SkinType.type4.Colour))
                skinButton(type: SkinType.type5, buttonColour: Color(rgba: SkinType.type5.Colour))
                skinButton(type: SkinType.type6, buttonColour: Color(rgba: SkinType.type6.Colour))
            }
        }
    }
    
    func skinButton(type: SkinType, buttonColour: Color) -> some View {
            ToggleButton(
                colour: buttonColour,
                skinType: type.stringValue,
                active: selectedType == type.stringValue
            )
            .onTapGesture {
                withAnimation {
                    if selectedType == type.stringValue {
                        selectedType = nil
                    } else {
                        selectedType = type.stringValue
                        userManager.updateUserSkinType(skin: type)
                    }
                }
                if selectedType != nil {
                    canPress =  true
                } else {
                    canPress = false
                }
            }
        }
    
    var nextButton: some View {
        Button(action: {
            isPressed = true
            isWelcomeScreenOver = true
        }) {
            HStack() {
                Text("Let's Get Started")
                    .foregroundColor(.white)
                    .padding()
            }
            .background(canPress ? Color(red: 1.0, green: 0.4, blue: 0.2) : Color.gray)
            .clipShape(Capsule())
            .shadow(color: canPress ? Color(red: 1.0, green: 0.4, blue: 0.2) : Color.clear, radius: canPress ? 2 : 0)
        }
        .disabled(!canPress)
    }
}

#Preview {
    WelcomeView()
}
