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

struct ClearButton: ViewModifier {
    @Binding var text: String
    
    func body(content: Content) -> some View {
        HStack {
            content
            
            if !text.isEmpty {
                Button(action: {
                    text = ""
                }, label: {
                    Image(systemName: "xmark.circle")
                        .resizable()
                        .frame(width: 20, height: 20)
                        .foregroundColor(Color("1F2020"))
                })
                .padding(.trailing, 10)
            }
        }
    }
}

struct NavigationTitleColorModifier: ViewModifier {
    var color: Color
    
    func body(content: Content) -> some View {
        content
            .onAppear {
                UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor: UIColor(color)]
                UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: UIColor(color)]
            }
    }
}


struct SegmentedControlStyleModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .onAppear {
                UISegmentedControl.appearance().setTitleTextAttributes(
                    [.font: UIFont(name: "GmarketSansTTFMedium", size: Config.SEGMENTED_CONTROL_STYLE_FONT_SIZE) ?? UIFont.systemFont(ofSize: Config.SEGMENTED_CONTROL_STYLE_FONT_SIZE)], for: .normal)
                UISegmentedControl.appearance().setTitleTextAttributes(
                    [.font: UIFont(name: "GmarketSansTTFMedium", size: Config.SEGMENTED_CONTROL_STYLE_FONT_SIZE) ?? UIFont.systemFont(ofSize: Config.SEGMENTED_CONTROL_STYLE_FONT_SIZE)], for: .selected)
            }
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
    
    func clearButton(text: Binding<String>) -> some View {
        modifier(ClearButton(text: text))
    }
    
    func navigationTitleColor(_ color: Color) -> some View {
        self.modifier(NavigationTitleColorModifier(color: color))
    }
    
    func segmentedControlStyle() -> some View {
        self.modifier(SegmentedControlStyleModifier())
    }
}
