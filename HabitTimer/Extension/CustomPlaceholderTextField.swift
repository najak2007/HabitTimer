//
//  CustomPlaceholderTextField.swift
//  running
//
//  Created by najak on 9/1/25.
//

import SwiftUI

struct CustomPlaceholderTextField: View {
    @Binding var text: String
    var placeholder: String
    var placeholderColor: Color
    
    var body: some View {
        ZStack(alignment: .leading) {
            if text.isEmpty {
                Text(placeholder)
                    .foregroundColor(placeholderColor)
            }
            TextField("", text: $text)
        }
    }
}
