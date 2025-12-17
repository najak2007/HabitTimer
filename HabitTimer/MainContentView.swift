//
//  MainContentView.swift
//  HabitTimer
//
//  Created by najak on 11/12/25.
//

import SwiftUI
import HapticsManager

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
    @State private var isOnlyWeekDayShow: Bool = true
    @State private var backgroundDate: Date? = nil
    @State private var isDeleteAlertShow: Bool = false

    @State private var backgroundDateText: String = ""

    
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
                                HStack(spacing: 10){
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
                                    Spacer()
                                    
                                    Text(toDoListViewModel.getToDoListForWeekDays(toDoListData: toDoListViewModel.toDoList[index]))
                                        .font(.custom("GmarketSansTTFMedium", size: 15))
                                        .foregroundColor(.black)
                                        .frame(minWidth: 20)
                                        .padding(.vertical, 5)
                                        .padding(.horizontal, 8)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 16)
                                                .stroke(Color.black.opacity(0.6), lineWidth: 0.8)
                                        )
#endif
                                    Image(systemName: "list.bullet.circle")
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
                            
                            if self.isPomodoroShow == true {
                                self.isAddToDoListShow = false
                            }
                        }
                        .id(toDoListViewModel.toDoList[index].id)
                        .overlay {
                            VStack {
                                HStack {
                                    Text(toDoListViewModel.toDoList[index].createDate.MMddDot)
                                        .font(.custom("GmarketSansTTFBold", size: 15))
                                        .foregroundColor(.black)
                                        .padding(.vertical, 5)
                                        .padding(.horizontal, 8)
                                        .padding(.top, 25)
                                        .padding(.leading, 48)
                                        
                                    Spacer()
                                }
                                
                                Spacer()
                            }
                        }
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
                                if date.yyyyMMdd == Date().yyyyMMdd {
                                    withAnimation(.easeIn(duration: Config.TEXTVIEW_SHOW_ANIMATION_INTERVAL)) {
                                        self.isAddToDoListShow.toggle()
                                    }
                                } else {
                                    setDateChange()
                                }
                            }, label: {
                                if date.yyyyMMdd == Date().yyyyMMdd {
                                    Image(systemName: "square.and.pencil")
                                        .resizable()
                                        .frame(width: 25, height: 25)
                                        .foregroundColor(Color("1F2020"))
                                } else {
                                    Text("오늘")
                                        .font(.custom("GmarketSansTTFMedium", size: 15))
                                        .foregroundColor(Color("1F2020"))
                                }
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
                                    bind()
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
                    VStack {
                        HStack(spacing: 5) {
                            Spacer()
                            
                            Text("요일별")
                                .font(.custom("GmarketSansTTFMedium", size: 16))
                        
                            Toggle(isOn: $isOnlyWeekDayShow) {

                            }
                            .labelsHidden()
                            .controlSize(ControlSize.mini)
                            .onChange(of: isOnlyWeekDayShow) { oldValue, newValue in
                                bind()
                            }
                            .hapticFeedback(.impact(.medium), trigger: isOnlyWeekDayShow)
                        }
                        .padding(.horizontal, 10)
                        .padding(.top, -34)
                        
                        Spacer()
                    }
                }
                
                
                .overlay {
                    VStack(spacing: 10) {
                        Spacer()
                        
                        HStack(spacing: 10) {
                            VStack(alignment: .leading, spacing: 0) {
#if __NOT_USE__
                                UITextViewRepresentable(text: $messageText, isFocused: $isFocused, inputHeight: $inputHeight)
                                    .frame(height: inputHeight)
#else
                                UITextViewRepresentable(text: $messageText, isFocused: $isAddToDoListShow, inputHeight: $inputHeight)
                                    .frame(height: inputHeight)
#endif
                            }
                            
                            Button(action: {
                                guard messageText.isEmpty == false else { return }
                                let trimString = messageText.trimmingCharacters(in: .whitespacesAndNewlines)
                                guard trimString.isEmpty == false else { return }
                                
                                let newToDoData = ToDoListData()
                                newToDoData.setMessageText(messageText: trimString)
                                toDoListViewModel.addToDoList(newToDoData, isOnlyWeekDayShow)
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

        .fullScreenCover(isPresented: $isPomodoroShow, onDismiss: {
            
        }, content: {
            PomodoroView(toDoListViewModel: toDoListViewModel, toDoListData: $toDoListViewModel.selectedToDoListData, selectedDate: $date, isOnlyWeekDayShow: $isOnlyWeekDayShow, index: toDoListViewModel.selectedIndex)
        })
        
        .transaction { transaction in
            transaction.disablesAnimations = true
            
        }
        .fullScreenCover(isPresented: $isToDoListHistoryView, content: {
            ToDoDataResultListView(toDoListData: $toDoListViewModel.selectedToDoListData)
        })
        .onAppear {
            toDoListViewModel.deleteToDoListUndo(date, isOnlyWeekDayShow) { _ in
                timerManager.midnightCheckTimer()
            }
        }
        .onReceive(midnightPassed) {
            setDateChange()
        }
        .onChange(of: scenePhase) { oldValue, newValue in
            print("MainContentView oldValue = \(oldValue), newValue = \(newValue)")
            
            if oldValue == .inactive, newValue == .background {
                timerManager.midnightResetTimer()
                self.backgroundDate = Date()
                
                self.backgroundDateText = self.backgroundDate?.yyMMddDot ?? ""
#if DEBUG_USE
                self.backgroundDate = CalendarViewModel().subtractDaysFromDate(days: 1, from: Date())
#endif
            } else if oldValue == .background, newValue == .inactive {
#if DEBUG
                toast = Toast(type: .info, title: "백그라운드 = \(backgroundDate?.yyyyMMdd ?? "")", message: "지금 = \(Date().yyyyMMdd), 선택된 날짜 = \(date.yyyyMMdd)", position: .top)
#endif

                if backgroundDate != nil {
                    if backgroundDate?.yyyyMMdd != Date().yyyyMMdd {
                        setDateChange()
                    }
                }
                backgroundDate = nil
                timerManager.midnightCheckTimer()
            }
        }
        .toastView(toast: $toast)
        .confirmationDialog("삭제 범위를 선택하세요.", isPresented: $isDeleteAlertShow, titleVisibility: .visible) {
            Button("\"\(date.weekDay)\" 요일 에서만 삭제") {
                guard let toDoDataID = toDoListViewModel.deleteToDoListID else { return }
                toDoListViewModel.deleteToWeekDays(toDoListDataID: toDoDataID, date: date, isOnlyWeekDayShow: isOnlyWeekDayShow)
            }
            
            Button("모두 삭제", role: .destructive) {
                guard let toDoDataID = toDoListViewModel.deleteToDoListID else { return }
                toDoListViewModel.deleteToDoListData(toDoListDataID: toDoDataID, date: date, isOnlyWeekDayShow: isOnlyWeekDayShow)
            }
            
            Button("취소") {
                
            }
        }
        .onChange(of: isDeleteAlertShow) { oldValue, newValue in
            if oldValue, newValue == false {

                toDoListViewModel.deleteToDoListUndo(date, isOnlyWeekDayShow) { isUndo in
                    if isUndo {
                        toast = Toast(type: .info, title: "", message: "삭제가 취소 되었습니다.", position: .top)
                    }
                }
                toDoListViewModel.deleteToDoListID = nil
            }
        }

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
        self.isDeleteAlertShow.toggle()
        
        toDoListViewModel.deleteToDoListID = toDoListViewModel.toDoList[deleteIndex].id
        
        toDoListViewModel.deleteToDoList(toDoListViewModel.toDoList[deleteIndex], date, isOnlyWeekDayShow)
    }
    
    func bind(_ isLoading: Bool = false) {
        toDoListViewModel.fetchToDoList(date, isOnlyWeekDayShow)
    }
}



extension EditMode {
    mutating func toggle() {
        self = self == .active ? .inactive : .active
    }
}
