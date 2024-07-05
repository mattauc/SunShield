//
//  SettingsPage.swift
//  SunShield
//
//  Created by Matthew Auciello on 21/6/2024.
//

import SwiftUI

struct SettingsPage: View {
    var accentColour: Color
    @State private var selectedSkin = 0
    
    @EnvironmentObject var userManager: UserManager
    
    // Settings view
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Sunscreen & Skin Profile")) {
                    Text("Select Skin Type")
                        .bold()
                    Picker("Options", selection: $selectedSkin) {
                        ForEach(0..<6) { index in
                            Text(userManager.skinTypes[index].rawValue).tag(index)
                        }
                    }
                    .onChange(of: selectedSkin) {
                        userManager.updateUserSkinType(skin: userManager.skinTypes[selectedSkin])
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    
                    Text("You selected: Type \(userManager.skinTypes[selectedSkin].rawValue)")
                }

                Section(header:Text("Personalization")) {
                    Text("🎨 Theme - Coming soon")
                }
                
                Section() {
                    
                    NavigationLink(destination: SkinTypeInfo()) {
                        Text("📘 Skin Types")
                    }
                
                    NavigationLink(destination: UVIndexInfo()) {
                        Text("☀️ UV Index")
                    }
                }
                
                Section {
                    NavigationLink(destination: Acknowledgements()) {
                        Text("Acknowledgements")
                    }
                    
                    NavigationLink(destination: PrivacyPolicy()) {
                        Text("Privacy Policy")
                    }
                    
                    NavigationLink(destination: TermsAndConditions()) {
                        Text("Terms and Conditions")
                            .foregroundColor(.red)
                    }
                }
            }
            .navigationTitle("Settings")
        }
        .onAppear {
            if let index = userManager.skinTypes.firstIndex(where: { $0 == userManager.userSkin }) {
                self.selectedSkin = index
            }
        }
        .accentColor(self.accentColour)
    }
}

struct Acknowledgements: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                Link("Skincure: An Innovative Smart Phone-Based Application To Assist In Melanoma Early Detection And Prevention.", destination: URL(string: "https://www.researchgate.net/publication/270593542_Skincure_An_Innovative_Smart_Phone-Based_Application_To_Assist_In_Melanoma_Early_Detection_And_Prevention")!)
                    .font(.headline)
                
                Text("Abuzaghleh, Omar & Faezipour, Miad & Barkana, Buket. (2015). Signal & Image Processing : An International Journal. 5. 10.5121/sipij.2014.5601.")
                    .font(.subheadline)
            }
            .padding()
        }
        .navigationTitle("Acknowledgements")
    }
}

#Preview {
    SettingsPage(accentColour: .blue)
        .environmentObject(UserManager())
}
