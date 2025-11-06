//
//  View+Extension.swift
//  TodayToDoList
//
//  Created by najak on 6/30/25.
//

import SwiftUI

struct ClearBackgroundView: UIViewRepresentable {
    func makeUIView(context: Context) -> UIView {
        let view = UIView()
        
        DispatchQueue.main.async {
            view.superview?.superview?.backgroundColor = .clear
        }
        return view
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {
        
    }
}

struct ClearBackgroundViewModifier: ViewModifier {
    func body(content: Content) -> some View {
        if #available(iOS 16.4, *) {
            content
                .presentationBackground(.clear)
        } else {
            content
                .background(ClearBackgroundView())
        }
    }
}

struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners
    
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        
        return Path(path.cgPath)
    }
}

extension View {
    func endTextEditing() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
    
    func clearModalBackground() -> some View {
        self.modifier(ClearBackgroundViewModifier())
    }
    
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedCorner(radius: radius, corners: corners))
    }
}
