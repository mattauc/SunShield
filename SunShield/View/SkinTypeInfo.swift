//
//  SkinTypeInfo.swift
//  SunShield
//
//  Created by Matthew Auciello on 29/6/2024.
//

import SwiftUI

struct SkinTypeInfo: View {
    
    // Displays the skin type information page
    var body: some View {
        GroupBox {
            ScrollView {
                VStack {
                    buildSkinType(colour: Color(rgba: SkinType.type1.Colour), type: SkinType.type1, features: "Pale white skin, blue/green eyes, blond/red hair.", tanning: "Always burns, does not tan.")
                    Divider()
                    buildSkinType(colour: Color(rgba: SkinType.type2.Colour), type: SkinType.type2, features: "Fair Skin, blue eyes.", tanning: "Burns easily, tans poorly.")
                    Divider()
                    buildSkinType(colour: Color(rgba: SkinType.type3.Colour), type: SkinType.type3, features: "Darker white skin.", tanning: "Tans after initial burn.")
                    Divider()
                    buildSkinType(colour: Color(rgba: SkinType.type4.Colour), type: SkinType.type4, features: "Light brown skin.", tanning: "Burns minimally, tans easily.")
                    Divider()
                    buildSkinType(colour: Color(rgba: SkinType.type5.Colour), type: SkinType.type5, features: "Brown skin.", tanning: "Rarely burns, tans darkly easily.")
                    Divider()
                    buildSkinType(colour: Color(rgba: SkinType.type6.Colour), type: SkinType.type6, features: "Dark brown or black skin.", tanning: "Never burns, always tans darkly.")
                }
            }
        } label: {
            NavigationLink(destination: Text("")) {
                VStack {
                    Link("Skin Type Information", destination: URL(string: "https://www.fda.gov/radiation-emitting-products/tanning/your-skin")!)
                        .font(.largeTitle)
                        .bold()
                    Divider()
                }
            }
        }
        .groupBoxStyle(.custom)
        .ignoresSafeArea()
        .padding(.top)
        
    }
    
    // Builds each skin type tab
    func buildSkinType(colour: Color, type: SkinType, features: String, tanning: String) -> some View {
        HStack(alignment: .top) {
            ZStack {
                RoundedRectangle(cornerRadius: 15)
                    .fill(colour)
                    .frame(width:100, height: 100)
                Text(type.rawValue)
                    .bold()
                    .font(.title)
            }
            VStack(alignment: .leading) {
                Text("Features")
                    .bold()
                Text(features)
                    .padding(.bottom, 5)
                Text("Tanning Ability")
                    .bold()
                Text(tanning)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

#Preview {
    SkinTypeInfo()
}
