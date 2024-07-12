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
    @State private var selectedSPF = 0
    @State private var selectedUnit: TemperatureUnit = .metric
    
    @EnvironmentObject var userManager: UserManager
    
    // Settings view
    var body: some View {
        NavigationView {
            Form {
                Section {
                    selectSkinType
                        .modifier(CustomBackgroundModifier())
                }
                
                Section {
                    selectSpfType
                        .modifier(CustomBackgroundModifier())
                }
                
                Section(header: Text("Temperature unit")) {
                    temperatureSelect
                        .modifier(CustomBackgroundModifier())
                }
                
                Section(header: Text("Additional Information")) {
                    NavigationLink(destination: SkinTypeInfo()) {
                        Text("📘 Skin Types")
                    }
                    .modifier(CustomBackgroundModifier())
                
                    NavigationLink(destination: UVIndexInfo()) {
                        Text("☀️ UV Index")
                    
                    }
                    .modifier(CustomBackgroundModifier())
                }
                
                Section {
                    NavigationLink(destination: Acknowledgements()) {
                        Text("Acknowledgements")
                    }
                    .modifier(CustomBackgroundModifier())
                    
                    NavigationLink(destination: PrivacyPolicy()) {
                        Text("Privacy Policy")
                    }
                    .modifier(CustomBackgroundModifier())
                    
                    NavigationLink(destination: TermsAndConditions()) {
                        Text("Terms and Conditions")
                    }
                    .modifier(CustomBackgroundModifier())
                }
            }
            .background(LinearGradient(gradient: Gradient(colors: [accentColour.opacity(0.3), Color.clear]), startPoint: .top, endPoint: .bottom).edgesIgnoringSafeArea(.all))
            .scrollContentBackground(.hidden)
            .navigationTitle("Settings")
        }
        .onAppear {
            if let skinIndex = userManager.skinTypes.firstIndex(where: { $0 == userManager.userSkin }) {
                self.selectedSkin = skinIndex
            }
                
            if let spfIndex = userManager.spfTypes.firstIndex(where: { $0 == userManager.userSpf }) {
                self.selectedSPF = spfIndex
            }
            
            if let unitIndex = userManager.unitTypes.firstIndex(where: { $0 == userManager.unitType }) {
                self.selectedUnit = userManager.unitTypes[unitIndex]
            }
        }
        .accentColor(self.accentColour)
        
    }
    
    var temperatureSelect: some View {
        Group {
            Picker("Temperature unit", selection: $selectedUnit) {
                ForEach(TemperatureUnit.allCases) { unit in
                    Text(unit.rawValue).tag(unit)
                }
            }
            .onChange(of: selectedUnit) {
                userManager.updateTempUnit(unit: selectedUnit)
            }
        }
    }
    
    // Select skin type picker view
    var selectSkinType: some View {
        Group {
            Text("Select skin type")
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
    }
    
    // Select spf type picker view
    var selectSpfType: some View {
        Group {
            Text("Select your SPF")
                .bold()
            Picker("Options", selection: $selectedSPF) {
                ForEach(0..<4) { index in
                    Text(userManager.spfTypes[index].id).tag(index)
                }
            }
            .onChange(of: selectedSPF) {
                userManager.updateUserSPF(spf: userManager.spfTypes[selectedSPF])
            }
            .pickerStyle(SegmentedPickerStyle())
            Text("You selected: SPF \(userManager.spfTypes[selectedSPF].rawValue)")
        }
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

struct CustomBackgroundModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .listRowBackground(
                RoundedRectangle(cornerRadius: 0)
                    .fill(Color.gray)
                    .opacity(0.2)
            )
    }
}

#Preview {
    SettingsPage(accentColour: .blue)
        .environmentObject(UserManager())
}
