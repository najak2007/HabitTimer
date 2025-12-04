//
//  TextWithColoredSubstring.swift
//  HabitTimer
//
//  Created by 오션블루 on 12/4/25.
//

import SwiftUI

struct TextWithColoredSubstring: View {
    var originalText: String
    var coloredSubstring: String
    
    var body: some View {
        if let coloredRange = originalText.range(of: coloredSubstring) {
            let beforeRange = originalText[..<coloredRange.lowerBound]
            let coloredText = originalText[coloredRange]
            let afterRange = originalText[coloredRange.upperBound...]
            
            return Text(beforeRange)
                .font(.custom("GmarketSansTTFMedium", size: 15))
                .foregroundColor(.black)
            + Text(coloredText)
                .font(.custom("GmarketSansTTFMedium", size: 15))
                .foregroundColor(.red)
            + Text(afterRange)
                .font(.custom("GmarketSansTTFMedium", size: 15))
                .foregroundColor(.black)
        } else {
            return Text(originalText)
                .font(.custom("GmarketSansTTFMedium", size: 15))
        }
    }
}
