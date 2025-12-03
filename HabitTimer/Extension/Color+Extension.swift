//
//  Color+Extension.swift
//  ballTouch
//
//  Created by najak on 10/2/25.
//

import SwiftUI

extension Color {
    static let errorRed = Color.init(hex: "FF5959")
    static let errorGreen = Color.init(hex: "4CD964")
    /// 말풍선 색상
    static let bubble = Color.init(hex: "D8EBFC")
    
    static let main = Color.init(hex: "FF7E7E")
    /// Sub / main
    static let sub = Color.init(hex: "FF9A9A")
    /// Medium
    static let medium = Color.init(hex: "FFF0F0")
    /// Bright
    static let bright = Color.init(hex: "FFF3F3")
    
    /// Black
    static let symBlack = Color.init(hex: "313439")
    /// Gray6
    static let symGray6 = Color.init(hex: "42454A")
    /// Gray5
    static let symGray5 = Color.init(hex: "69707B")
    /// Gray4
    static let symGray4 = Color.init(hex: "9BA3AE")
    /// Gray3
    static let symGray3 = Color.init(hex: "CCD2DA")
    /// Gray2
    static let symGray2 = Color.init(hex: "E8EAED")
    /// Gray1
    static let symGray1 = Color.init(hex: "F3F5F8")
    
    static let main_FF7E7E = Color.init(hex: "FF7E7E")
    static let sub_FFA9A9 = Color.init(hex: "FF9A9A")
    static let medium_FFF0F0 = Color.init(hex: "FFF0F0")
    static let bright_FFF3F3 = Color.init(hex: "FFF3F3")
    
    // gray scale
    static let black2D2D2D = Color.init(hex: "2D2D2D")
    static let gray6_42454A = Color.init(hex: "42454A")
    static let gray5_69707B = Color.init(hex: "69707B")
    static let gray4_9BA3AE = Color.init(hex: "9BA3AE")
    static let gray3_CCD2DA = Color.init(hex: "CCD2DA")
    static let gray2_E8EAED = Color.init(hex: "E8EAED ")
    static let gray1_F3F5F8 = Color.init(hex: "F3F5F8")
    
    
    static var random: Color {
        return Color(
            red: .random(in: 0...1),
            green: .random(in: 0...1),
            blue: .random(in: 0...1)
        )
    }
    
    init(hex: String) {
        let scanner = Scanner(string: hex)
        _ = scanner.scanString("#")
        
        var rgb: UInt64 = 0
        scanner.scanHexInt64(&rgb)
        
        let r = Double((rgb >> 16) & 0xFF) / 255.0
        let g = Double((rgb >>  8) & 0xFF) / 255.0
        let b = Double((rgb >>  0) & 0xFF) / 255.0
        self.init(red: r, green: g, blue: b)
    }
}
