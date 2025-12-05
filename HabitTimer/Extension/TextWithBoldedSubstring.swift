//
//  TextWithBoldedSubstring.swift
//  HabitTimer
//
//  Created by 오션블루 on 12/4/25.
//

import SwiftUI

struct TextWithBoldedSubstring: View {
    var originalText: String
    var boldedSubstring: String
    var sunString: String = "일"
    
    
    var body: some View {
        if let boldedRange = originalText.range(of: boldedSubstring) {
            let beforeRange = originalText[..<boldedRange.lowerBound]
            let boldedText = originalText[boldedRange]
            let afterRange = originalText[boldedRange.upperBound...]
            
            return Text(beforeRange)
                .font(.custom("GmarketSansTTFMedium", size: 15))
                .foregroundColor(.black)
            + Text(boldedText)
                .font(.custom("GmarketSansTTFBold", size: 15))
                .foregroundColor(.black)
            + Text(afterRange)
                .font(.custom("GmarketSansTTFMedium", size: 15))
                .foregroundColor(.black)
        } else {
            return Text(originalText)
                .font(.custom("GmarketSansTTFMedium", size: 15))
        }
    }
}
