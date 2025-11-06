//
//  CustomButtonStyle.swift
//  running
//
//  Created by najak on 9/1/25.
//

import SwiftUI

struct CustomButtonStyle: ButtonStyle {
    var selected: Bool
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding()
            .overlay(
                RoundedRectangle(cornerRadius: 0)
                    .stroke(selected ? Color("55CBCD") : Color(hex: "9CA3AF").opacity(0.2), lineWidth: selected ? 2 : 1)
            )
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)          // 눌렸을 때 약간 축소
    }
}
