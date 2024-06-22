//
//  CustomTab.swift
//  SunShield
//
//  Created by Matthew Auciello on 21/6/2024.
//

import SwiftUI

struct CustomTab: View {
    @Binding var tabSelection: Int
    @Namespace private var animationNamespace
    
    let tabBarItems: [(image: String, title: String)] = [
    ("timer", "Timer"),
    ("house", "Home"),
    ("list.bullet", "Settings")]
    
    
    var body: some View {
        VStack {
            Capsule()
                .frame(height: 80)
                .foregroundColor(Color(.secondarySystemBackground))
                .shadow(radius: 1)
            HStack {
                ForEach(0..<3) { index in
                    Button {
                        tabSelection = index
                    } label: {
                        Image(systemName: tabBarItems[index].image)
                            .foregroundColor(index == tabSelection ? .blue : .gray)
                            .font(.largeTitle)
                
                    }
                }
            }
            .frame(height: 80)
        }
        .padding(.horizontal)
    }
}

#Preview {
    CustomTab(tabSelection: .constant(1))
}
