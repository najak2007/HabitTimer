//
//  ToDoListBubble.swift
//  HabitTimer
//
//  Created by najak on 11/10/25.
//

import SwiftUI

struct ToDoListView: View {
    let columns = [
        GridItem(.adaptive(minimum: 100, maximum: 300)),
        GridItem(.adaptive(minimum: 100, maximum: 300)),
    ]

    @StateObject private var toDoListViewModel = ToDoListViewModel()
    @State private var inputHeight: CGFloat = 42
    @State private var messageText: String = ""
    @State private var isFocused: Bool = false
    
    var body: some View {
#if true
        VStack {
            List {
                ForEach(toDoListViewModel.toDoList, id: \.id) { toDoListItem in
                    ToDoListRowView(toDoListItem: toDoListItem)
                        .listRowSeparator(.hidden)
                        .listRowBackground(Color.clear)
                        .listRowInsets(EdgeInsets())
                }
            }
            .scrollContentBackground(.hidden)
            .background(Color.clear)
            .contentMargins(.horizontal, 0)
            
            Spacer()

            HStack(spacing: 10) {
                VStack(alignment: .leading, spacing: 0) {
                    UITextViewRepresentable(text: $messageText, isFocused: $isFocused, inputHeight: $inputHeight)
                        .frame(height: inputHeight)
                }
                
                Button(action: {
                    guard messageText.isEmpty == false else  { return }
                    let trimString = messageText.trimmingCharacters(in: .whitespacesAndNewlines)
                    guard trimString.isEmpty == false else { return }

                    let newToDoData = ToDoListData()
                    newToDoData.setMessageText(messageText: trimString)
                    toDoListViewModel.addToDoList(newToDoData)
                    messageText = ""
                    
                }, label: {
                    Image(systemName: "arrowshape.up.circle.fill")
                        .resizable()
                        .frame(width: 40, height: 40)
                        .foregroundColor(Color("1F2020"))
                })
            }
            .padding(.horizontal, 10)
            .padding(.bottom, 10)
        }
#else
        LazyVGrid(columns: columns) {
            VideoAttachmentView(Image(.fish), isFromYou: false, shouldSendInTheFuture: false)
            
            ImageAttachmentView(Image(.jelly), isFromYou: true, shouldSendInTheFuture: false)

            
            Text("Check out this custom bubble")
                .toDoListBubblesStyle(isFromYou: false)

            Text("I can't believe you made this!")
                .toDoListBubblesStyle(isFromYou: true)
            
            Text("This is from someone else")
                .toDoListBubblesStyle(isFromYou: false)

            Text("규민이가 크리스마스 선물로 게임기를 사달라고 하네. 그런데 가격이 무려 110만원이 넘어... 산타에게 사달라고 한데.ㅠㅠ")
                .toDoListBubblesStyle(isFromYou: true, shouldSendInTheFuture: true)
            

            Text("")
            Text(":")
                .toDoListBubblesStyle(isFromYou: true)

        }.padding()
#endif
    }
}
