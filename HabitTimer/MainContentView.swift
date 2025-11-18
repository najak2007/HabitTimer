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
    @State private var messageText: String = ""
    @State private var isFocused: Bool = false
    @State private var inputHeight: CGFloat = 42
    @State private var editMode: EditMode = .inactive
    @State private var isEditing: Bool = false
    @State private var isAddToDoListShow: Bool = false
    @State private var isDeleteAction: Bool = false
    @State private var isDetailShow: Bool = false
    @State private var size: CGSize = .zero
    @State private var rowHeight: CGFloat = Config.TODOLIST_ROW_HEIGHT
    @State private var toast: Toast? = nil
    @State private var messageTextEditorID: String = ""
    @State private var selectedToDoListData: ToDoListData = ToDoListData()
    @State private var selectedIndex: Int = 0
    
    @Namespace private var animation
    
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
                            InputToDoListView(toDoListData: toDoListViewModel.toDoList[index], index: index, disabledID: $messageTextEditorID) { toDoListItem, mesageText in
                                
                            } inputErrorHandler: { errorMessage in
                                toast = Toast(type: .error, title: "", message: errorMessage)
                            }
                        }
                        .listRowSeparator(.hidden)
                        .listRowBackground(Color.white)
                        .listRowInsets(EdgeInsets())
                        .onTapGesture {
#if true
                            self.isDetailShow.toggle()
                            self.selectedToDoListData = toDoListViewModel.toDoList[index]
                            self.selectedIndex = index
#else
                            if editMode == .active {
                                messageTextEditorID = toDoListViewModel.toDoList[index].id
                            } else {
                                
                            }
#endif
                        }
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
                                withAnimation(.easeIn(duration: Config.TEXTVIEW_SHOW_ANIMATION_INTERVAL)) {
                                    self.isAddToDoListShow.toggle()
                                }
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
                        withAnimation(.easeOut(duration: Config.TEXTVIEW_SHOW_ANIMATION_INTERVAL)) {
                            self.isAddToDoListShow.toggle()
                        }
                    }
                }))
                .environment(\.editMode, $editMode)
                
                .scrollContentBackground(.hidden)
                .background(.white)
                .contentMargins(.horizontal, 0)
                .padding(.top, -34)
                
                .overlay {
                    VStack(spacing: 10) {
                        Spacer()
                        
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
                                withAnimation(.easeOut(duration: Config.TEXTVIEW_SHOW_ANIMATION_INTERVAL)) {
                                    self.isAddToDoListShow.toggle()
                                }
                            }, label: {
                                Image(systemName: "arrowshape.up.circle.fill")
                                    .resizable()
                                    .frame(width: 40, height: 40)
                                    .foregroundColor(Color("1F2020"))
                            })
                            
                        }
                        .padding()
                        .background(.white)
                        
                    }
                    .opacity(self.isAddToDoListShow == true ? 1 : 0)
                }
            }
        }
        .onChange(of: self.isAddToDoListShow) { oldValue, newValue in
            if oldValue, newValue == false {
                UIApplication.shared.endEditing()
            }
        }
        .onChange(of: self.editMode) { oldValue, newValue in
            if oldValue == .active, newValue == .inactive {
                self.messageTextEditorID = ""
                UIApplication.shared.endEditing()
            }
        }
        .fullScreenCover(isPresented: $isDetailShow, content: {
            PomodoroView(toDoListData: $selectedToDoListData, isDetailShow: $isDetailShow, index: self.selectedIndex)
        })
        .transaction { transaction in
            transaction.disablesAnimations = true
            
        }
        .toastView(toast: $toast)

        .ignoresSafeArea()
    }
    
    func getImageName(index: Int) -> String {
#if false        // 랜덤하게 배경 이미지 변경하기
        var remaining: Int = Int.random(in: 0...(postItName.count - 1))
#else
        var remaining = index % postItName.count
        
        if remaining >= postItName.count {
            remaining = 0
        }
#endif
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
