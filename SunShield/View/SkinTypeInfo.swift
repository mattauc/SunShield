//
//  SkinTypeInfo.swift
//  SunShield
//
//  Created by Matthew Auciello on 29/6/2024.
//

import SwiftUI

struct SkinTypeInfo: View {
    var body: some View {
        GroupBox {
            ScrollView {
                VStack {
                    buildSkinType(colour: Color(red: 255/255, green: 206/255, blue: 180/255), type: SkinType.type1, features: "Pale white skin, blue/green eyes, blond/red hair.", tanning: "Always burns, does not tan.")
                    Divider()
                    buildSkinType(colour: Color(red: 240/255, green: 184/255, blue: 160/255), type: SkinType.type2, features: "Fair Skin, blue eyes.", tanning: "Burns easily, tans poorly.")
                    Divider()
                    buildSkinType(colour: Color(red: 195/255, green: 149/255, blue: 130/255), type: SkinType.type3, features: "Darker white skin.", tanning: "Tans after initial burn.")
                    Divider()
                    buildSkinType(colour: Color(red: 165/255, green: 126/255, blue: 110/255), type: SkinType.type4, features: "Light brown skin.", tanning: "Burns minimally, tans easily.")
                    Divider()
                    buildSkinType(colour: Color(red: 120/255, green: 92/255, blue: 80/255), type: SkinType.type5, features: "Brown skin.", tanning: "Rarely burns, tans darkly easily.")
                    Divider()
                    buildSkinType(colour: Color(red: 75/255, green: 57/255, blue: 50/255), type: SkinType.type6, features: "Dark brown or black skin.", tanning: "Never burns, always tans darkly.")
                }
            }
        } label: {
            Text("Skin Type Information")
                .font(.largeTitle)
                .bold()
            Divider()
        }
        .groupBoxStyle(.custom)
        .ignoresSafeArea()
        .padding(.top)
        
    }
    
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
            //.padding(.vertical)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

#Preview {
    SkinTypeInfo()
}
