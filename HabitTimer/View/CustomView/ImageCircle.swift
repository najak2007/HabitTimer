//
//  ImageCircle.swift
//  running
//
//  Created by najak on 9/12/25.
//

import SwiftUI

enum ButtonPressType {
    case 짧게
    case 길게
}

struct ImageCircle: View {
    var uiImage: UIImage = UIImage(systemName: "figure.run")! as UIImage
    var longPressInterval: Double = 2.0
    @Binding var size: CGFloat
    var fontSize: CGFloat = 24
    var backgroundColor: Color = Color(hex: "#222222")
    var foregroundColor: Color = Color.white
    @GestureState private var isLongPressing = false
    var action: (ButtonPressType) -> Void
    
    var body: some View {
        Circle()
            .fill(foregroundColor)
            .frame(width: size, height: size)
            .overlay(
                Image(uiImage: uiImage)
                    .resizable()
                    .frame(width: size * 0.4, height: size * 0.4)
            )
            .gesture(LongPressGesture(minimumDuration: longPressInterval)
                .updating($isLongPressing) { value, state, _ in
                    state = value
                    action(.짧게)
                }
                .onEnded { value in
                    if value {
                        action(.길게)
                    }
                })
    }
}
