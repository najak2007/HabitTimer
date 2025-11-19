//
//  InputToDoListView.swift
//  HabitTimer
//
//  Created by 오션블루 on 11/17/25.
//

import Foundation
import SwiftUI
import UIKit


struct InputToDoListView: View {
    @Environment(\.presentationMode) var presentationMode

    var toDoListData: ToDoListData
    var index: Int
    var fontSize: CGFloat = 24
    var maxLine: Int = 5
    var maxWidth: CGFloat = 280
    
    @FocusState private var isKeyboardFocused: Bool
    @State private var messageText: String = ""
    @State private var originalText: String = ""
    @State private var color: Color = .primary
    @State private var inputHeight: CGFloat = 40
    @State private var inputWidth: CGFloat = 0
 
    var textEditorHandler: (ToDoListData, String) -> Void
    var inputErrorHandler: (String) -> Void
    
    var body: some View {
        VStack {
            TextField("작업할 일을 적어주세요.", text: $messageText, axis: .vertical)
                .font(.custom("GmarketSansTTFMedium", size: fontSize))
                .clearButton(text: $messageText)
                .lineLimit(1...maxLine)
                .multilineTextAlignment(messageText.isEmpty ? .leading : .center)
                .frame(maxWidth: maxWidth, idealHeight: 40, maxHeight: inputHeight/*Config.TODOLIST_ROW_HEIGHT - 40 */)
                .lineSpacing(5)
                .focused($isKeyboardFocused)
                .overlay(
                    RoundedRectangle(cornerRadius: 5)
                        .stroke(self.color, lineWidth: 3).opacity(0.6)
                )
                .shadow(color: .gray, radius: 5, x: 1, y: 2)
                .toolbar {
                    ToolbarItem(placement: .keyboard) {
                        HStack {
                            Spacer()
                            
                            Button(action: {
                                
                                let trimWhiteSpace = messageText.trimmingCharacters(in: .whitespacesAndNewlines)
                                
                                if trimWhiteSpace.isEmpty {
                                    inputErrorHandler("1글자 이상 입력해주세요.")
                                    return
                                } else {
                                    textEditorHandler(toDoListData, trimWhiteSpace)
                                }
                                
                                UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                            }, label: {
                                Text("완료")
                                    .font(.custom("GmarketSansTTFMedium", size: 24))
                            })
                        }
                    }
                }
                .onChange(of: messageText) { oldValue, newValue in
                    if newValue.count > Config.INPUT_TEXT_COUNT_LIMIT {
                        inputErrorHandler("\(Config.INPUT_TEXT_COUNT_LIMIT) 글자를 초과할 수 없습니다.")
                        messageText = oldValue
                    }
                    if oldValue != newValue {
                        self.inputHeight = setTextFieldHeight(text: newValue)
                    }
                }
                .onAppear {
                    self.messageText = toDoListData.messageText
                    self.originalText = toDoListData.messageText
                    
                    var remaining = index % Config.MAIN_STICKER_COUNT
                    
                    if remaining >= Config.MAIN_STICKER_COUNT {
                        remaining = 0
                    }
                    color = Color("STICKER_\(remaining)")
                }
        }
    }
    
    func calculateTextWidth(text: String, font: UIFont) -> CGFloat {
        let attributes = [NSAttributedString.Key.font: font]
        let size = (text as NSString).boundingRect(
            with: CGSize(width: CGFloat.greatestFiniteMagnitude, height: .greatestFiniteMagnitude),
            options: .usesLineFragmentOrigin,
            attributes: attributes,
            context: nil
        )
        return size.width
    }
    
    func setTextFieldHeight(text: String) -> CGFloat {
        if text.contains(where: { $0.isNewline }) {
            return Config.INPUT_TEXT_FIELD_MAX_HEIGHT
        }
        
        let textWidth: CGFloat = self.calculateTextWidth(text: text, font: UIFont(name: "GmarketSansTTFMedium", size: fontSize)!)

        if maxWidth <= textWidth - Config.INPUT_TEXT_FIELD_MARGIN {
            return Config.INPUT_TEXT_FIELD_MAX_HEIGHT
        }
        return Config.INPUT_TEXT_FIELD_DEFAULT_HEIGHT
    }
}
