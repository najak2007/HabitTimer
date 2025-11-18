//
//  InputToDoListView.swift
//  HabitTimer
//
//  Created by 오션블루 on 11/17/25.
//

import Foundation
import SwiftUI

struct InputToDoListView: View {
    @Environment(\.presentationMode) var presentationMode
    
    @FocusState private var isKeyboardFocused: Bool
    @State private var messageText: String = ""
    @State private var originalText: String = ""
    var toDoListData: ToDoListData
    var index: Int
    @Binding var disabledID: String
    
    var textEditorHandler: (ToDoListData, String) -> Void
    var inputErrorHandler: (String) -> Void
    
    var body: some View {
        VStack {
            TextField("", text: $messageText, axis: .vertical)
                .font(.custom("GmarketSansTTFMedium", size: 24))
                .lineLimit(1...5)
                .multilineTextAlignment(.center)
                .frame(maxWidth: 280, maxHeight: Config.TODOLIST_ROW_HEIGHT - 40)
                .lineSpacing(5)
                .focused($isKeyboardFocused)
                .disabled(disabledID == toDoListData.id ? false : true)
                .onSubmit {
                    let trimWhiteSpace = messageText.trimmingCharacters(in: .whitespacesAndNewlines)
                    
                    if trimWhiteSpace.isEmpty {
                        inputErrorHandler("1글자 이상 입력해주세요.")
                        return
                    } else {
                        textEditorHandler(toDoListData, trimWhiteSpace)
                    }
                }
                .onChange(of: messageText) { oldValue, newValue in
                    if newValue.count > Config.INPUT_TEXT_COUNT_LIMIT {
                        inputErrorHandler("\(Config.INPUT_TEXT_COUNT_LIMIT) 글자를 초과할 수 없습니다.")
                        messageText = oldValue
                    }
                }
                .onChange(of: disabledID) { oldValue, newValue in
                    if toDoListData.id == newValue, newValue.isEmpty == false {
                        isKeyboardFocused.toggle()
                    }
                }
                .onAppear {
                    self.messageText = toDoListData.messageText
                    self.originalText = toDoListData.messageText
                }
                .toolbar {
                    if disabledID == toDoListData.id {
                        ToolbarItem(placement: .keyboard) {
                            HStack {
                                Spacer()
                                Button("Done") {
                                    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                                }
                            }
                        }
                    }
                }
        }
    }
}
