//
//  CardContent.swift
//  SunShield
//
//  Created by Matthew Auciello on 22/6/2024.
//

import SwiftUI

struct CardContent: View {
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

struct CustomGroupBox: GroupBoxStyle {
    func makeBody(configuration: Configuration) -> some View {
        VStack(alignment: .leading) {
            configuration.label
                .bold()
                .font(.callout)
            configuration.content
            
        }
        .padding()
        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 15))
    }
}

extension GroupBoxStyle where Self == CustomGroupBox {
    static var custom: CustomGroupBox { .init() }
}

#Preview {
    CardContent()
}
