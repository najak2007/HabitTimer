//
//  UITextViewRepresentable.swift
//  HabitTimer
//
//  Created by najak on 11/11/25.
//

import SwiftUI
import Foundation
import UIKit

struct UITextViewRepresentable: UIViewRepresentable {
    @Binding var text: String
    @Binding var isFocused: Bool
    @Binding var inputHeight: CGFloat
    
    
    func makeUIView(context: UIViewRepresentableContext<UITextViewRepresentable>) -> UITextView {
        let textView = UITextView(frame: .zero)
        textView.delegate = context.coordinator
        textView.font = UIFont(name: "GmarketSansTTFMedium", size: 18)
        textView.textContainerInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        textView.layer.borderWidth = 1.0
        textView.layer.borderColor = UIColor.darkGray.cgColor
        textView.backgroundColor = UIColor.white
        textView.layer.cornerRadius = 8.0
        textView.layer.masksToBounds = true
        textView.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        return textView
    }
    
    func makeCoordinator() -> UITextViewRepresentable.Coordinator {
        Coordinator(text: self.$text, isFocused: self.$isFocused, inputHeight: $inputHeight)
    }
    
    func updateUIView(_ uiView: UITextView, context: UIViewRepresentableContext<UITextViewRepresentable>) {
        uiView.text = self.text
        
        if isFocused {
            uiView.becomeFirstResponder()
        } else {
            uiView.resignFirstResponder()
        }
    }
    
    class Coordinator: NSObject, UITextViewDelegate {
        @Binding var text: String
        @Binding var isFocused: Bool
        @Binding var inputHeight: CGFloat
        
        let maxHeight: CGFloat = 250
        
        init(text: Binding<String>, isFocused: Binding<Bool>, inputHeight: Binding<CGFloat>) {
            self._text = text
            self._isFocused = isFocused
            self._inputHeight = inputHeight
        }
        
        func textViewDidChange(_ textView: UITextView) {
            let spacing = textView.font!.lineHeight
            if textView.contentSize.height > inputHeight && inputHeight <= maxHeight - spacing {
                inputHeight += spacing
            } else if text == "" {
                inputHeight = 42
            }
        }
        
        func textViewDidChangeSelection(_ textView: UITextView) {
            self.text = textView.text ?? ""
        }
        
        func textViewDidBeginEditing(_ textView: UITextView) {
            self.isFocused = true
            textView.layer.borderColor = UIColor(named: "1F2020")?.cgColor
        }
        
        func textViewDidEndEditing(_ textView: UITextView) {
            self.isFocused = false
            textView.layer.borderColor = UIColor.darkGray.cgColor
        }
    }
}
