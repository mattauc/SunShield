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
                    
                    Link("Terms of Service", destination: URL(string: "https://www.ashwingur.com/")!)
                        .foregroundColor(.red)
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

#Preview {
    SettingsPage(accentColour: .blue)
        .environmentObject(UserManager())
}
