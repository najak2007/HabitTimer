//
//  NSMutableAttributedString.swift
//  TodayToDoList
//
//  Created by 오션블루 on 6/30/25.
//

import Foundation
import UIKit


//let originalText = "This text is normal, but this part is bold and italic."
//let attributedString = NSMutableAttributedString(string: originalText)
//
//// Define the range for bold and italic text
//let targetSubstring = "bold and italic"
//let range = (originalText as NSString).range(of: targetSubstring)
//
//// Get the system font
//let baseFont = UIFont.systemFont(ofSize: 17.0)
//
//// Create a font descriptor with bold and italic traits
//if let boldItalicFontDescriptor = baseFont.fontDescriptor.withSymbolicTraits([.traitBold, .traitItalic]) {
//    // Create a new font from the descriptor (size 0 uses the original font's size)
//    let boldItalicFont = UIFont(descriptor: boldItalicFontDescriptor, size: 0)
//
//    // Apply the bold and italic font to the specified range
//    attributedString.addAttribute(.font, value: boldItalicFont, range: range)
//}
//
//// You can now set this attributed string to a UILabel or UITextView
//let label = UILabel()
//label.attributedText = attributedString


extension NSMutableAttributedString {
    func bold(_ string: String, _ fontSize: CGFloat, _ color: UIColor = UIColor(named: "222222") ?? .darkGray) -> NSMutableAttributedString {
        let font = UIFont(name: "GmarketSansTTFBold", size: fontSize) ?? UIFont.boldSystemFont(ofSize: fontSize)
        let attributes: [NSAttributedString.Key: Any] = [.font: font, .foregroundColor: color]
        self.append(NSAttributedString(string: string, attributes: attributes))
        return self
    }
    
    func regular(_ string: String, _ fontSize: CGFloat, _ color: UIColor = UIColor(named: "222222") ?? .darkGray) -> NSMutableAttributedString {
        let font = UIFont(name: "GmarketSansTTFLight", size: fontSize) ?? UIFont.systemFont(ofSize: fontSize)
        let attributes: [NSAttributedString.Key: Any] = [.font: font, .foregroundColor: color]
        self.append(NSAttributedString(string: string, attributes: attributes))
        return self
    }
    
    func medium(_ string: String, _ fontSize: CGFloat, _ color: UIColor = UIColor(named: "222222") ?? .darkGray) -> NSMutableAttributedString {
        let font = UIFont(name: "GmarketSansTTFMedium", size: fontSize) ?? UIFont.systemFont(ofSize: fontSize)
        let attributes: [NSAttributedString.Key: Any] = [.font: font, .foregroundColor: color]
        self.append(NSAttributedString(string: string, attributes: attributes))
        return self
    }
    
    func semibold(_ string: String, _ fontSize: CGFloat, _ color: UIColor = UIColor(named: "222222") ?? .darkGray) -> NSMutableAttributedString {
        let font = UIFont(name: "Pretendard-SemiBold", size: fontSize) ?? UIFont.systemFont(ofSize: fontSize)
        let attributes: [NSAttributedString.Key: Any] = [.font: font, .foregroundColor: color]
        self.append(NSAttributedString(string: string, attributes: attributes))
        return self
    }

    
    func thin(_ string: String, _ fontSize: CGFloat, _ color: UIColor = UIColor(named: "222222") ?? .darkGray) -> NSMutableAttributedString {
        let font = UIFont(name: "Pretendard-Thin", size: fontSize) ?? UIFont.systemFont(ofSize: fontSize)
        let attributes: [NSAttributedString.Key: Any] = [.font: font, .foregroundColor: color]
        self.append(NSAttributedString(string: string, attributes: attributes))
        return self
    }
    
    func light(_ string: String, _ fontSize: CGFloat, _ color: UIColor = UIColor(named: "222222") ?? .darkGray) -> NSMutableAttributedString {
        let font = UIFont(name: "Pretendard-Light", size: fontSize) ?? UIFont.systemFont(ofSize: fontSize)
        let attributes: [NSAttributedString.Key: Any] = [.font: font, .foregroundColor: color]
        self.append(NSAttributedString(string: string, attributes: attributes))
        return self
    }
    
    func underlined(_ string: String, _ fontSize: CGFloat) -> NSMutableAttributedString {
        let font = UIFont(name: "Pretendard-Regular", size: fontSize) ?? UIFont.systemFont(ofSize: fontSize)
        let attributes: [NSAttributedString.Key: Any] = [.font: font, .underlineStyle: NSUnderlineStyle.single.rawValue]
        self.append(NSAttributedString(string: string, attributes: attributes))
        return self
    }
    
    func black(_ string: String, _ fontSize: CGFloat, _ color: UIColor = UIColor(named: "222222") ?? .darkGray) -> NSMutableAttributedString {
        let font = UIFont(name: "Pretendard-Black", size: fontSize) ?? UIFont.systemFont(ofSize: fontSize)
        let attributes: [NSAttributedString.Key: Any] = [.font: font, .foregroundColor: color]
        self.append(NSAttributedString(string: string, attributes: attributes))
        return self
    }
    
    func extrabold(_ string: String, _ fontSize: CGFloat, _ color: UIColor = UIColor(named: "222222") ?? .darkGray) -> NSMutableAttributedString {
        let font = UIFont(name: "Pretendard-ExtraBold", size: fontSize) ?? UIFont.systemFont(ofSize: fontSize)
        let attributes: [NSAttributedString.Key: Any] = [.font: font, .foregroundColor: color]
        self.append(NSAttributedString(string: string, attributes: attributes))
        return self
    }
    
    func extralight(_ string: String, _ fontSize: CGFloat, _ color: UIColor = UIColor(named: "222222") ?? .darkGray) -> NSMutableAttributedString {
        let font = UIFont(name: "Pretendard-ExtraLight", size: fontSize) ?? UIFont.systemFont(ofSize: fontSize)
        let attributes: [NSAttributedString.Key: Any] = [.font: font, .foregroundColor: color]
        self.append(NSAttributedString(string: string, attributes: attributes))
        return self
    }
}
