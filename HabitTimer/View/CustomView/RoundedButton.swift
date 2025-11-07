//
//  RoundedButton.swift
//  running
//
//  Created by najak on 9/4/25.
//

import SwiftUI

struct RoundedButton: View {
    var leadingImage: Image? = nil
    var title: String
    var trailingImage: Image? = nil
    var fontSize: CGFloat = 18
    var fontName: String = "GmarketSansTTFMedium"
    var backgroundColor: Color = Color("1F2020")
    var foregroundColor: Color = Color("B_1F2020")
    var height: CGFloat = 40
    var backgroundWidth: CGFloat = 120
    var action: () -> Void
    
    var body: some View {
        HStack {
            Button(action: action) {
                if leadingImage != nil || trailingImage != nil {
                    HStack(spacing: 4) {
                        if leadingImage != nil {
                            leadingImage!
                            
                            Text(title)
                            
                        }
                        
                        if trailingImage != nil {
                            trailingImage
                        }
                    }
                } else {
                    Text(title)
                }
            }
            .buttonStyle(.plain)
            .frame(maxWidth: backgroundWidth, maxHeight: height)
            .padding(.horizontal, 8)
            .font(.custom(fontName, size: fontSize))
            .background(backgroundColor)                    // 배경색 설정
            .foregroundStyle(foregroundColor)               // 글자 색상 설정
            .cornerRadius(10)
        }
        .padding(.horizontal)
    }
}
