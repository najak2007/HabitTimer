//
//  ImageCircleButton.swift
//  running
//
//  Created by najak on 9/4/25.
//

import SwiftUI

struct ImageCircleButton: View {
    var uiImage: UIImage = UIImage(systemName: "figure.run")! as UIImage
    @Binding var size: CGFloat
    var fontSize: CGFloat = 24
    var backgroundColor: Color = Color(hex: "#222222")
    var foregroundColor: Color = Color.white
    var action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Circle()
                .fill(foregroundColor)
                .frame(width: size, height: size)
                .overlay(
                    Image(uiImage: uiImage)
                        .resizable()
                        .frame(width: size * 0.4, height: size * 0.4)
                )
        }
    }
}
