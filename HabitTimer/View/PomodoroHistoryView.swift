//
//  PomodoroHistoryView.swift
//  HabitTimer
//
//  Created by najak on 11/25/25.
//

import SwiftUI
import Combine

struct PomodoroHistoryView: View {
    @Environment(\.dismiss) var dismiss
    var toDoListViewModel: ToDoListViewModel
    @Binding var toDoListData: ToDoListData
    @Binding var isDetailShow: Bool
    @State private var messageText: String = ""
    var index: Int = 0
    
    
    var body: some View {
        NavigationView {
            VStack {
                HStack(spacing: 8) {
                    
                    Spacer()
                    
                    Button(action: {
                        dismiss()
                    }, label: {
                        Image(systemName: "xmark.circle.fill")
                            .resizable()
                            .frame(width: 35, height: 35)
                            .foregroundColor(Color("1F2020"))
                    })
                }
                .padding(.horizontal, 20)
                
                Spacer()
            }
        }
    }
}
