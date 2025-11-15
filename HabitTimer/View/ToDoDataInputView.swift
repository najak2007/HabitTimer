//
//  ToDoDataInputView.swift
//  HabitTimer
//
//  Created by najak on 11/14/25.
//

import SwiftUI

struct ToDoDataInputView: View {
    @Environment(\.presentationMode) var presentationMode
    @StateObject private var toDoListViewModel = ToDoListViewModel()
    
    @State private var messageText: String = ""
    @State private var isFocused: Bool = false
    @State private var inputHeight: CGFloat = 42
    
    var body: some View {
        VStack {
            HStack(spacing: 10) {
                VStack(alignment: .leading, spacing: 0) {
                    UITextViewRepresentable(text: $messageText, isFocused: $isFocused, inputHeight: $inputHeight)
                        .frame(height: inputHeight)
                }
                
                Button(action: {
                    guard messageText.isEmpty == false else { return }
                    let trimString = messageText.trimmingCharacters(in: .whitespacesAndNewlines)
                    guard trimString.isEmpty == false else { return }
                    
                    let newToDoData = ToDoListData()
                    newToDoData.setMessageText(messageText: trimString)
                    toDoListViewModel.addToDoList(newToDoData)
                    messageText = ""
                    presentationMode.wrappedValue.dismiss()
                }, label: {
                    Image(systemName: "arrowshape.up.circle.fill")
                        .resizable()
                        .frame(width: 40, height: 40)
                        .foregroundColor(Color("1F2020"))
                })
            }
            .padding(.horizontal, 10)
        }
        .frame(height: 100)
    }
}
