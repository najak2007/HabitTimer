//
//  MainContentView.swift
//  HabitTimer
//
//  Created by najak on 11/12/25.
//

import SwiftUI

struct PostitListView: View {
    let postItName = [
        "Post_IT_Y",
        "Post_IT_B",
    ]
 
    @StateObject private var toDoListViewModel = ToDoListViewModel()
    @State private var isEditMode: Bool = false
    @State private var messageText: String = ""
    @State private var isFocused: Bool = false
    @State private var inputHeight: CGFloat = 42
    
    let coloredNavAppearance = UINavigationBarAppearance()
    
    init() {
        coloredNavAppearance.configureWithOpaqueBackground()
        coloredNavAppearance.backgroundColor = UIColor.white
        coloredNavAppearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        coloredNavAppearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        UINavigationBar.appearance().standardAppearance = coloredNavAppearance
        UINavigationBar.appearance().scrollEdgeAppearance = coloredNavAppearance
    }
    
    var body: some View {
        NavigationView {
            ScrollViewReader { proxy in
                List {
                    ForEach(toDoListViewModel.toDoList.indices, id: \.self) { index in
                        ZStack {
                            Image(getImageName(index: index))
                                .resizable()
                            
                            Text(toDoListViewModel.toDoList[index].messageText)
                                .font(.custom("GmarketSansTTFMedium", size: 24))
                                .frame(width: 300, height: 300)
                                
                        }
                        .listRowSeparator(.hidden)
                        .listRowBackground(Color.white)
                        .listRowInsets(EdgeInsets())
                        .id(toDoListViewModel.toDoList[index].id)
                    }
                }
                .onChange(of: toDoListViewModel.toDoList.count) { oldValue, newValue in
                    if let lastToDoItem = toDoListViewModel.toDoList.last {
                        withAnimation {
                            proxy.scrollTo(lastToDoItem.id, anchor: .bottom)
                        }
                    }
                }
                .onAppear {
                    if let lastToDoItem = toDoListViewModel.toDoList.last {
                        withAnimation {
                            proxy.scrollTo(lastToDoItem.id, anchor: .bottom)
                        }
                    }
                }
                
                .scrollContentBackground(.hidden)
                .background(.white)
                .contentMargins(.horizontal, 0)
                .padding(.top, -32)
                
//                HStack(spacing: 10) {
//                    VStack(alignment: .leading, spacing: 0) {
//                        UITextViewRepresentable(text: $messageText, isFocused: $isFocused, inputHeight: $inputHeight)
//                            .frame(height: inputHeight)
//                    }
//                    
//                    Button(action: {
//                        guard messageText.isEmpty == false else { return }
//                        let trimString = messageText.trimmingCharacters(in: .whitespacesAndNewlines)
//                        guard trimString.isEmpty == false else { return }
//                        
//                        let newToDoData = ToDoListData()
//                        newToDoData.setMessageText(messageText: trimString)
//                        toDoListViewModel.addToDoList(newToDoData)
//                        messageText = ""
//                    }, label: {
//                        Image(systemName: "arrowshape.up.circle.fill")
//                            .resizable()
//                            .frame(width: 40, height: 40)
//                            .foregroundColor(Color("1F2020"))
//                    })
//                }
//                .padding(.horizontal, 10)
//                .padding(.bottom, 10)
//                .background(.clear)
            }
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(
                leading: Button(action: {
                    
                }, label: {
                    Text("편집")
                        .font(.custom("GmarketSansTTFMedium", size: 16))
                        .foregroundColor(.black)
                })
                .buttonStyle(PlainButtonStyle()),
                
                trailing: Button(action: {
                    
                }, label: {
                    Image(systemName: "square.and.pencil")
                        .resizable()
                        .frame(width: 30, height: 30)
                        .foregroundColor(Color("1F2020"))
                })
                .buttonStyle(PlainButtonStyle())
            )
            

        }
    }
    
    func getImageName(index: Int) -> String {
        var remaining = index % postItName.count
        
        if remaining >= postItName.count {
            remaining = 0
        }
        return postItName[remaining]
    }
}
