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
            var beforeRange = originalText[..<boldedRange.lowerBound]
            var boldedText = originalText[boldedRange]
            var afterRange = originalText[boldedRange.upperBound...]
            
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
            if let subRange = originalText.range(of: sunString) {
                let beforeRange = originalText[..<subRange.lowerBound]
                let boldedText = originalText[subRange]
                let afterRange = originalText[subRange.upperBound...]
                
                return Text(beforeRange)
                    .font(.custom("GmarketSansTTFMedium", size: 15))
                    .foregroundColor(.black)
            }
            
            
            return Text(originalText)
                .font(.custom("GmarketSansTTFMedium", size: 15))
        }
    }
}
