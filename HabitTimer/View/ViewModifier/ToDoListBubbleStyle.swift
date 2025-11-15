//
//  ToDoListBubbleStyle.swift
//  HabitTimer
//
//  Created by najak on 11/10/25.
//

import SwiftUI

struct ToDoListBubbleStyle: ViewModifier {
    let isFromYou: Bool
    let shouldSendInTheFuture: Bool
    var toDoListFillColor: Color {
        if shouldSendInTheFuture {
            return Color.white
        } else if isFromYou {
            return Color.blue
        } else {
            return Color.secondary.opacity(0.2)
        }
    }
    
    var forgroundColor: Color {
        if shouldSendInTheFuture {
            return Color.blue
        } else if isFromYou {
            return Color.white
        } else {
            return Color.primary
        }
    }
    
    func body(content: Content) -> some View {
        content
            .foregroundStyle(forgroundColor)
            .padding(.vertical, 8)
            .padding(.horizontal, 20)
            .lineSpacing(5)
            .padding(isFromYou ? .trailing : .leading, 8)
            .background(
                ToDoBubble()
                    .fill(toDoListFillColor)
                    .rotation3DEffect(isFromYou ? .degrees(0) : .degrees(180), axis: (x: 0, y: 1, z: 0))
            )
            .padding(10)
    }
}

extension View {
    func toDoListBubblesStyle(isFromYou: Bool, shouldSendInTheFuture: Bool = false) -> some View {
        modifier(ToDoListBubbleStyle(isFromYou: isFromYou, shouldSendInTheFuture: shouldSendInTheFuture))
    }
    
    @ViewBuilder
    func ImageAttachmentView(_ thumbnail: Image, isFromYou: Bool, shouldSendInTheFuture: Bool) -> some View {
        var foregroundColor: Color {
            if shouldSendInTheFuture {
                return Color.blue
            } else if isFromYou {
                return Color.white
            } else {
                return Color.primary
            }
        }
        
        thumbnail
            .resizable()
            .scaledToFit()
            .mask (
                ToDoBubble()
                    .fill()
                    .rotation3DEffect(isFromYou ? .degrees(0) : .degrees(180), axis: (x: 0, y: 1, z: 0))
            )
    }
    
    @ViewBuilder
    func VideoAttachmentView(_ thumbnail: Image, isFromYou: Bool, shouldSendInTheFuture: Bool) -> some View {
        var forgroundColor: Color {
            if shouldSendInTheFuture {
                return Color.blue
            } else if isFromYou {
                return Color.white
            } else {
                return Color.primary
            }
        }
        
        ZStack {
            thumbnail
                .resizable()
                .scaledToFit()
                .mask(
                    ToDoBubble()
                        .fill()
                        .stroke(Color.blue, style: StrokeStyle(dash: [shouldSendInTheFuture ? 6 : 0]))
                        .rotation3DEffect(isFromYou ? .degrees(0) : .degrees(180), axis: (x: 0, y: 1, z: 0))
                )
            
            Image(systemName: "play.fill")
                .resizable()
                .scaledToFit()
                .frame(width: 10)
                .padding(8)
                .background(.ultraThinMaterial)
                .foregroundStyle(.black)
                .clipShape(Circle())
        }
    }
}
