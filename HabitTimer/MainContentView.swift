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
    @State private var midnightWorkItem: DispatchWorkItem?
    @State private var messageText: String = ""
    @State private var isFocused: Bool = false
    @State private var inputHeight: CGFloat = 42
    @State private var editMode: EditMode = .inactive
    @State private var isEditing: Bool = false
    @State private var isAddToDoListShow: Bool = false
    @State private var isDeleteAction: Bool = false
    @State private var isPomodoroShow: Bool = false
    @State private var isToDoListHistoryView: Bool = false
    @State private var isSiriRegister: Bool = false
    @State private var size: CGSize = .zero
    @State private var rowHeight: CGFloat = Config.TODOLIST_ROW_HEIGHT
    @State private var toast: Toast? = nil
    @State private var messageTextEditorID: String = ""
    @State private var textWidth: CGFloat = 0
    @State private var date = Date()
    @State private var backgroundDate: Date? = nil
    @StateObject private var timerManager = TimerManager()
    
    @Namespace private var animation
    
    let notiManager = NotificationManager.instance
    
    let coloredNavAppearance = UINavigationBarAppearance()
    @Environment(\.scenePhase) var scenePhase
    
    init() {
        coloredNavAppearance.configureWithOpaqueBackground()
        coloredNavAppearance.backgroundColor = UIColor.white
        coloredNavAppearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        coloredNavAppearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        UINavigationBar.appearance().standardAppearance = coloredNavAppearance
        UINavigationBar.appearance().scrollEdgeAppearance = coloredNavAppearance
        
        notiManager.requestAuthorization()
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
                                HStack {
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

#if __NOT_USE__
                                    TextWithBoldedSubstring(originalText: toDoListViewModel.getToDoListForWeekDays(toDoListData: toDoListViewModel.toDoList[index]), boldedSubstring: Date().weekDay)
                                        .padding(.vertical, 5)
                                        .padding(.horizontal, 8)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 16)
                                                .stroke(Color.black.opacity(0.6), lineWidth: 1)
                                        )
#else
                                    Text(toDoListViewModel.getToDoListForWeekDays(toDoListData: toDoListViewModel.toDoList[index]))
                                        .font(.custom("GmarketSansTTFMedium", size: 15))
                                        .foregroundColor(.black)
                                        .padding(.vertical, 5)
                                        .padding(.horizontal, 8)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 16)
                                                .stroke(Color.black.opacity(0.6), lineWidth: 1)
                                        )
                                        .padding(.leading, 62)
                                    Spacer()
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
                            self.isPomodoroShow.toggle()
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
                            Text(date.yyMMddDotE)
                                .font(.custom("GmarketSansTTFBold", size: Config.MAIN_HEADER_TITLE_FONT_SIZE))
                                .foregroundColor(.black)
                                .onChange(of: date) { oldValue, newValue in
                                    bind(oldValue != newValue)
                                }
                            
                            Image(systemName: "arrowtriangle.down.circle")
                                .resizable()
                                .frame(width: 20, height: 20)
                                .foregroundColor(.black)
                        }
                        .overlay {
                            DatePicker(selection: $date, displayedComponents: [.date]) {
                                
                            }
                            .labelsHidden()
                            .colorMultiply(.clear)
                            .datePickerStyle(.compact)
                            .environment(\.locale, Locale(identifier: String(Locale.preferredLanguages[0])))
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
                    VStack(alignment: .center) {
                        Spacer()
                    
                        Image("icon_empty")
                            .resizable()
                            .frame(width: 280, height: 187)
                    
                        Spacer()
                    }
                    .opacity(self.toDoListViewModel.toDoList.isEmpty ? 1 : 0)
                }
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
        .fullScreenCover(isPresented: $isPomodoroShow, content: {
            PomodoroView(toDoListViewModel: toDoListViewModel, toDoListData: $toDoListViewModel.selectedToDoListData, index: toDoListViewModel.selectedIndex)
        })
        .transaction { transaction in
            transaction.disablesAnimations = true
            
        }
        .fullScreenCover(isPresented: $isToDoListHistoryView, content: {
            ToDoDataResultListView(toDoListData: $toDoListViewModel.selectedToDoListData)
        })
        .onAppear {
            timerManager.midnightCheckTimer()
        }
        .onReceive(midnightPassed) {
            setDateChange()
        }
        .onChange(of: scenePhase) { oldValue, newValue in
            print("MainContentView oldValue = \(oldValue), newValue = \(newValue)")
            
            if oldValue == .inactive, newValue == .background {
                timerManager.midnightResetTimer()
                self.backgroundDate = Date()
                self.backgroundDate = CalendarViewModel().subtractDaysFromDate(days: 1, from: Date())
            } else if oldValue == .background, newValue == .inactive {
                if backgroundDate != nil {
                    if backgroundDate?.yyyyMMdd != Date().yyyyMMdd {
 //                       setDateChange()
                    }
                }
                backgroundDate = nil
                timerManager.midnightCheckTimer()
            }
        }
        .toastView(toast: $toast)

        .ignoresSafeArea()
    }
    
    private func setDateChange() {
        self.date = Date()
        bind()
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
        toDoListViewModel.fetchToDoList(date)
    }
}



extension EditMode {
    mutating func toggle() {
        self = self == .active ? .inactive : .active
    }
}
