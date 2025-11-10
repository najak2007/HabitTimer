//
//  ToDoListBubble.swift
//  HabitTimer
//
//  Created by najak on 11/10/25.
//

import SwiftUI

struct ToDoListBubble: View {
#if true
    let columns = [
        GridItem(.flexible(minimum: 80, maximum: 300)),
    ]
#else
    let columns = [
        GridItem(.adaptive(minimum: 100, maximum: 300)),
        GridItem(.adaptive(minimum: 100, maximum: 300)),
    ]
#endif

    var body: some View {
#if false
        VStack {
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
