//
//  Button.swift
//  HabitTimer
//
//  Created by najak on 12/2/25.
//

import SwiftUI

public struct MainButtonStyle: ButtonStyle {
    var isButtonEnabled: Bool
    
    public init(isButtonEnabled: Bool) {
        self.isButtonEnabled = isButtonEnabled
    }
    
    public func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .frame(maxWidth: .infinity)
            .padding(.vertical, 17)
            .font(.custom("GmarketSansTTFMedium", size: 17))
            .foregroundColor(isButtonEnabled ? Color.white : Color.gray5_69707B)
            .background(isButtonEnabled ? Color.main_FF7E7E : Color.gray1_F3F5F8)
            .cornerRadius(15)
    }
}
