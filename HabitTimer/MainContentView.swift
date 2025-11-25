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
    @State private var isToDoListHistoryView: Bool = false
    @State private var isSiriRegister: Bool = false
    @State private var size: CGSize = .zero
    @State private var rowHeight: CGFloat = Config.TODOLIST_ROW_HEIGHT
    @State private var toast: Toast? = nil
    @State private var messageTextEditorID: String = ""
    @State private var textWidth: CGFloat = 0
    @State private var date = Date()
    
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
                            
                            
                            VStack(alignment: .trailing) {
                                HStack(spacing: 15) {
                                    Spacer()
                                    
#if __NOT_USE__
                                    Image(systemName: "siri")
                                        .resizable()
                                        .frame(width: 25, height: 25)
                                        .foregroundColor(.black)
                                        .onTapGesture {
                                            self.toDoListViewModel.selectedToDoListData = toDoListViewModel.toDoList[index]
                                            self.toDoListViewModel.selectedIndex = index
                                            self.isSiriRegister.toggle()
                                        }
                                        .frame(width: 40, height: 40)
#endif
                                    Image(systemName: "ellipsis.circle")
                                        .resizable()
                                        .frame(width: 25, height: 25)
                                        .foregroundColor(.black)
                                        .onTapGesture {
                                            self.toDoListViewModel.selectedToDoListData = toDoListViewModel.toDoList[index]
                                            self.toDoListViewModel.selectedIndex = index
                                            self.isToDoListHistoryView.toggle()
                                        }
                                        .frame(width: 40, height: 40)
                                        .padding(.trailing, 62)
                                }
                                .padding(.top, 55)
                                Spacer()
                            }
                            
                            
                            Text(toDoListViewModel.toDoList[index].messageText)
                                .font(.custom("GmarketSansTTFMedium", size: 24))
                                .foregroundColor(.black)
                                .lineLimit(1...5)
                                .multilineTextAlignment(.center)
                                .frame(maxWidth: 280, maxHeight: Config.TODOLIST_ROW_HEIGHT - 40)
                                .lineSpacing(5)
                        }
                        .listRowSeparator(.hidden)
                        .listRowBackground(Color.white)
                        .listRowInsets(EdgeInsets())
                        .onTapGesture {
                            self.toDoListViewModel.selectedToDoListData = toDoListViewModel.toDoList[index]
                            self.toDoListViewModel.selectedIndex = index
                            self.isDetailShow.toggle()
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
                    
                    ToolbarItem(placement: .title) {
                        HStack(spacing: 4) {
                            Text(date.yyMMddDot)
                                .font(.custom("GmarketSansTTFBold", size: Config.MAIN_HEADER_TITLE_FONT_SIZE))
                                .foregroundColor(Color("1F2020"))
                                .overlay {
                                    DatePicker(selection: $date, displayedComponents: [.date]) {
                                        
                                    }
                                    .labelsHidden()
                                    .colorMultiply(.clear)
                                    .datePickerStyle(.compact)
                                    .environment(\.locale, Locale(identifier: String(Locale.preferredLanguages[0])))
                                }
                                .onChange(of: date) { oldValue, newValue in
                                    bind(oldValue != newValue)
                                }
                            
                            Image(systemName: "arrowtriangle.down.circle")
                                .resizable()
                                .frame(width: 20, height: 20)
                                .foregroundColor(Color("1F2020"))
                        }
                    }
                    
                    ToolbarItem(placement: .navigationBarTrailing) {
                        if self.toDoListViewModel.toDoList.isEmpty {
                            EmptyView()
                        } else {
                            EditButton()
                                .foregroundColor(.black)
                        }
                    }
                }
                .toolbarBackground(.hidden, for: .navigationBar)
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
                                    .foregroundColor(.black)
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
            PomodoroView(toDoListViewModel: toDoListViewModel, toDoListData: $toDoListViewModel.selectedToDoListData , isDetailShow: $isDetailShow, index: toDoListViewModel.selectedIndex)
        })
        .transaction { transaction in
            transaction.disablesAnimations = true
            
        }
        .fullScreenCover(isPresented: $isToDoListHistoryView, content: {
            PomodoroHistoryView(toDoListViewModel: toDoListViewModel, toDoListData: $toDoListViewModel.selectedToDoListData , isDetailShow: $isDetailShow, index: toDoListViewModel.selectedIndex)
        })
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
    
    func bind(_ isLoading: Bool = false) {
        print("bind = \(isLoading)")
    }
}



extension EditMode {
    mutating func toggle() {
        self = self == .active ? .inactive : .active
    }
}
