//
//  CircleButton.swift
//  running
//
//  Created by najak on 9/4/25.
//

import SwiftUI

struct TextCircleButton: View {
    var title: String
    var size: CGFloat = 100
    var fontSize: CGFloat = 24
    var backgroundColor: Color = Color(hex: "#222222")
    var foregroundColor: Color = Color.white
    var action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Circle()
                .fill(backgroundColor)
                .frame(width: size, height: size)
                .overlay(
                    Text(title)
                        .font(.custom("GmarketSansTTFBold", size: fontSize))
                        .foregroundColor(foregroundColor)
                )
        }
    }
}
