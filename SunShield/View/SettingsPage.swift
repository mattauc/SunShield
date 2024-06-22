//
//  SettingsPage.swift
//  SunShield
//
//  Created by Matthew Auciello on 21/6/2024.
//

import SwiftUI

struct SettingsPage: View {
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Sunscreen & Skin Profile")) {
                    HStack {
                        
                    }
                }
                Section(header:Text("Personalization")) {
                    Text("🎨 Theme")
                }
                
                Section() {
                    Text("📘 Skin Types")
                    Text("☀️ UV Index")
                    Link("Terms of Service", destination: URL(string: "https://www.ashwingur.com/")!)
                        .foregroundColor(.red)
                }
            }
            .navigationTitle("Settings")
        }
        //.accentColor(.red)
    }
}

#Preview {
    SettingsPage()
}
