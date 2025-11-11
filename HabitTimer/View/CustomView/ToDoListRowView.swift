//
//  ToDoListRowView.swift
//  HabitTimer
//
//  Created by najak on 11/11/25.
//

import SwiftUI

struct TextWidthPreferenceKey: PreferenceKey {
    static var defaultValue: CGFloat = 0

    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = max(value, nextValue())
    }
}

struct ToDoListRowView: View {
    
    let toDoListItem: ToDoListData
    var isDateShow: Bool = false
    
    @State private var textWidth: CGFloat = .zero
    
    
    var body: some View {
        if isDateShow == false {
            HStack {
                if toDoListItem.isFromYou == true {
                    Spacer()
                }
                VStack(alignment: .trailing) {
                    Text(toDoListItem.messageText)
                        .toDoListBubblesStyle(isFromYou: toDoListItem.isFromYou)
                        .font(.custom("GmarketSansTTFMedium", size: 18))
                }
                if toDoListItem.isFromYou == false {
                    Spacer()
                }
            }
            .padding(.horizontal, 0)
        } else {
            VStack(spacing: 5) {
                RoundedButton(title: toDoListItem.date.yyyyMMddKR, fontSize: 14, backgroundColor: Color("1F2020").opacity(0.6), action: {
                    
                })
                
                HStack {
                    if toDoListItem.isFromYou == true {
                        Spacer()
                    }
                    VStack(alignment: .trailing) {
                        Text(toDoListItem.messageText)
                            .toDoListBubblesStyle(isFromYou: toDoListItem.isFromYou)
                            .font(.custom("GmarketSansTTFMedium", size: 18))
                    }
                    if toDoListItem.isFromYou == false {
                        Spacer()
                    }
                }
                .padding(.horizontal, 0)
            }
        }
    }
}
