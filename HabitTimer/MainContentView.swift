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
        "Post_IT_G",
        "Post_IT_P",
        "Post_IT_R"
    ]
 
    @StateObject private var toDoListViewModel = ToDoListViewModel()
    @State private var isEditMode: Bool = false
    @State private var messageText: String = ""
    @State private var isFocused: Bool = false
    @State private var inputHeight: CGFloat = 42
    @State private var editMode: EditMode = .inactive
    @State private var isEditing: Bool = false
    @State private var isAddToDoListShow: Bool = false
    @State private var isDeleteAction: Bool = false
    
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
                                .frame(width: 280, height: 300)
                                .lineSpacing(5)
                            
                        }
                        .listRowSeparator(.hidden)
                        .listRowBackground(Color.white)
                        .listRowInsets(EdgeInsets())
                        .id(toDoListViewModel.toDoList[index].id)
                    }
                    .onDelete(perform: deleteItems)
                }
                .onChange(of: toDoListViewModel.toDoList.count) { oldValue, newValue in
                    if self.isDeleteAction == true {
                        self.isDeleteAction = false
                        return
                    }
                    if let lastToDoItem = toDoListViewModel.toDoList.last {
                        withAnimation {
                            proxy.scrollTo(lastToDoItem.id, anchor: .bottom)
                        }
                    }
                }
                .onAppear {
                    if let lastToDoItem = toDoListViewModel.toDoList.last {
                        proxy.scrollTo(lastToDoItem.id, anchor: .bottom)
                    }
                }
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        if self.editMode == .inactive {
                            Button(action: {
                                self.isAddToDoListShow.toggle()
                            }, label: {
                                Image(systemName: "square.and.pencil")
                                    .resizable()
                                    .frame(width: 25, height: 25)
                                    .foregroundColor(Color("1F2020"))
                            })
                            .buttonStyle(PlainButtonStyle())
                        }
                    }
                    
                    ToolbarItem(placement: .navigationBarTrailing) {
                        EditButton()
                    }
                }
                .simultaneousGesture(DragGesture().onChanged({ _ in
                    if self.isAddToDoListShow {
                        self.isAddToDoListShow.toggle()
                    }
                }))
                .environment(\.editMode, $editMode)
                
                .scrollContentBackground(.hidden)
                .background(.white)
                .contentMargins(.horizontal, 0)
                .padding(.top, -34)
                
                
                if isAddToDoListShow == true {
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
                            self.isAddToDoListShow.toggle()
                        }, label: {
                            Image(systemName: "arrowshape.up.circle.fill")
                                .resizable()
                                .frame(width: 40, height: 40)
                                .foregroundColor(Color("1F2020"))
                        })
                    }
                    .padding(.horizontal, 10)
                    .padding(.bottom, 10)
                    .background(.clear)
                }
            }
        }
    }
    
    func getImageName(index: Int) -> String {
        var remaining = index % postItName.count
        
        if remaining >= postItName.count {
            remaining = 0
        }
        return postItName[remaining]
    }
    
    func deleteItems(at offsets: IndexSet) {
        guard let deleteIndex = toDoListViewModel.toDoList.indices.firstIndex(where: { offsets.contains($0) }) else { return }
        guard deleteIndex < toDoListViewModel.toDoList.count else { return }
        
        self.isDeleteAction = true
        toDoListViewModel.deleteToDoList(toDoListViewModel.toDoList[deleteIndex])
    }
}

extension EditMode {
    mutating func toggle() {
        self = self == .active ? .inactive : .active
    }
}
