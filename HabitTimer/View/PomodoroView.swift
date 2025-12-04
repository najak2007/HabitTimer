//
//  PomodoroView.swift
//  HabitTimer
//
//  Created by najak on 11/6/25.
//

import SwiftUI
import Combine

struct PomodoroView: View {
    
    @Environment(\.dismiss) var dismiss
    @Environment(\.scenePhase) var scenePhase
    
    private let secondTimer = Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()
    
    @StateObject private var timerManager = TimerManager()
    
    @State private var themeColor: Color = Color("TimerSecond_B")
    
    @State private var startTime: Date = Date()
    @State private var endTime: Double = Config.POMODORO_TIME_DEFAULT_COUNT
    
    @State private var startPercent: CGFloat = 0
    @State private var endPercent: CGFloat = 360
    @State private var color: Color = .red
    @State private var backgroundColor: Color = Color("CircleTimeBackground")
    @State private var elapsedTime: Double = 0.0
    @State private var selectedMinute: Int = Config.POMODORO_WORK_TIME_MINUTE
    @State private var minuteValue: Int = Config.POMODORO_WORK_TIME_MINUTE
    @State private var minuteBreakValue: Int = Config.POMODORO_BREAK_TIME_MINUTE
    @State private var pomodoroState: PomodoroState = .초기화
    @State private var timerDisplay: String = "00:00"
    @State private var toast: Toast? = nil
    @State private var isDoneButtonShow: Bool = false
    @State private var isTimePickerShow: Bool = false
    @State private var isMenuShow: Bool = false
    @State private var isAlarmStatus: Bool = false       // 알림 모드 설정
    @State private var isFullScreen: Bool = false
    @State private var timeRemaining: Double = Double(Config.POMODORO_WORK_TIME_MINUTE) * Config.POMODORO_TIME_MINUTE
    @State private var pomodoroScenePhase: ScenePhase? = nil
    @State private var weekDays: Int = 0
    @State private var weekDaysList: [WeekDayItem] = []
    
    var toDoListViewModel: ToDoListViewModel
    @Binding var toDoListData: ToDoListData
    @State private var messageText: String = ""
    var index: Int = 0
    
    @State private var showing = false
    
    var body: some View {
        NavigationView {
            VStack {
                HStack(spacing: 8) {
                    Button(action: {
                        dismiss()
                    }, label: {
                        Image(systemName: "chevron.backward.circle.fill")
                            .resizable()
                            .frame(width: 35, height: 35)
                            .foregroundColor(Color("1F2020"))
                    })
                    
                    Spacer()

                    InputToDoListView(toDoListData: toDoListData, messageText: $messageText, index: index, fontSize: 22, maxLine: 3, maxWidth: 300) { toDoListItem, mesageText in
                        
                    } inputErrorHandler: { errorMessage in
                        toast = Toast(type: .error, title: "", message: errorMessage)
                    } inputBeginEditingHandler: { isShow in
                        self.isDoneButtonShow = isShow
                    }

                    Spacer()
                    
                    Button(action: {
                        if self.isDoneButtonShow {
                            toDoListViewModel.updateToDoMessageText(toDoListData: toDoListData, messageText: messageText)
                            toast = Toast(type: .info, title: "", message: "저장되었습니다.", position: .top)
                            self.isDoneButtonShow.toggle()
                        } else {
                            self.isMenuShow.toggle()
                        }
                        self.endTextEditing()
                    }, label: {
                        Image(systemName: self.isDoneButtonShow ? "checkmark.circle.fill" : "ellipsis.circle.fill")
                            .resizable()
                            .frame(width: 35, height: 35)
                            .foregroundColor(Color("1F2020"))
                    })
                }
                .frame(height: Config.NAVIGATION_HEIGHT)
                .padding(.horizontal, 20)
                .onAppear {
                    self.messageText = self.toDoListData.messageText
                }
                
                
                GeometryReader { geometryProxy in
                    ZStack(alignment: .center) {
                        if self.isFullScreen {
                            ZStack {
                                Picker("", selection: $selectedMinute) {
                                    ForEach(1..<61) { minute in
                                        Text(String(format: "%02d:00", minute))
                                            .font(.system(size: 38, weight: .semibold))
                                            .monospacedDigit()
                                            .foregroundColor(Color("1F2020"))
                                            .italic()
                                            .tag(minute)
                                    }
                                }
                                .pickerStyle(.inline)
                                .clipped()
                                .onChange(of: selectedMinute) { oldValue, newValue in
                                    minuteValue = newValue
                                    
                                    if pomodoroState != .할일_완료 {
                                        withAnimation(.easeOut(duration: 0.2)) {
                                            self.isTimePickerShow.toggle()
                                            self.setStartAction()
                                        }
                                    }
                                }
                                .opacity(self.isTimePickerShow ? 1: 0)

                                VStack(alignment: .center, spacing: 10) {
                                    Spacer()

                                    Text(timerDisplay.divisionNewLineFirst)
                                        .font(.system(size: 220, weight: .semibold))
                                        .multilineTextAlignment(.center)
                                        .lineLimit(1)
                                        .monospacedDigit()
                                        .background(.clear)
                                        .foregroundColor(Color("1F2020"))
                                        .italic()
                                        .frame(maxWidth: .infinity, maxHeight: 170)
                                    
                                    Text(timerDisplay.divisionNewLineLast)
                                        .font(.system(size: 220, weight: .semibold))
                                        .multilineTextAlignment(.center)
                                        .lineLimit(1)
                                        .monospacedDigit()
                                        .background(.clear)
                                        .foregroundColor(Color("1F2020"))
                                        .italic()
                                        .frame(maxWidth: .infinity, maxHeight: 170)
                                    
                                    Spacer()
                                }
                                .opacity(self.isTimePickerShow ? 0 : 1)
                                .onTapGesture {
                                    if pomodoroState == .할일_완료 || pomodoroState == .휴식_완료 || pomodoroState == .초기화 {
                                        self.isTimePickerShow.toggle()
                                    } else {
                                        toast = Toast(type: .info, title: "", message: "현재 상태에서는 시간을 변경할 수 없습니다.", position: .top)
                                    }
                                }
                            }
                        } else {
                            Circle()
                                .foregroundColor(self.color)
                            
                            Path { path in
                                let size = geometryProxy.size
                                let center = CGPoint(x: size.width / 2.0,
                                                     y: size.height / 2.0)
                                let radius = min(size.width, size.height) / 2.0
                                path.move(to: center)
                                path.addArc(center: center,
                                            radius: radius,
                                            startAngle: .init(degrees: Double(self.startPercent)),
                                            endAngle: .init(degrees: Double(self.endPercent)),
                                            clockwise: true)
                                
                            }
                            .rotation(.init(degrees: 270))
                            .foregroundColor(self.backgroundColor)
                            .frame(width: geometryProxy.size.width,
                                   height: geometryProxy.size.height,
                                   alignment: .center)
                            
                            Circle()
                                .strokeBorder(self.color, lineWidth: Config.TIME_CIRCLE_ROUND_WIDTH / 2)
                                .overlay {
                                    Circle()
                                        .trim(from: timerManager.timeRemaining/Config.POMODORO_TIME_MINUTE > 0.016 ? (timerManager.timeRemaining/Config.POMODORO_TIME_MINUTE) - 0.000008 : 0.0, to: (timerManager.timeRemaining/Config.POMODORO_TIME_MINUTE) == 0 ? 0.0 : (timerManager.timeRemaining/Config.POMODORO_TIME_MINUTE) + 0.008)
                                        .stroke(themeColor, style: StrokeStyle(lineWidth: Config.TIME_CIRCLE_ROUND_WIDTH, lineCap: .round, lineJoin: .round))
                                        .rotationEffect(Angle(degrees: 270))
                                        .animation(.smooth(duration: timerManager.timeRemaining == 0 ? 0.0 : 1.0), value: timerManager.timeRemaining)
                                        .padding(Config.TIME_CIRCLE_ROUND_WIDTH / 4)
                                    
                                    
                                }
                            ZStack {
                                Picker("", selection: $selectedMinute) {
                                    ForEach(1..<61) { minute in
                                        Text(String(format: "%02d:00", minute))
                                            .font(.system(size: 38, weight: .semibold))
                                            .monospacedDigit()
                                            .foregroundColor(Color("1F2020"))
                                            .italic()
                                            .tag(minute)
                                    }
                                }
                                .pickerStyle(.inline)
                                .clipped()
                                .onChange(of: selectedMinute) { oldValue, newValue in
                                    minuteValue = newValue
                                    
                                    if pomodoroState != .할일_완료 {
                                        withAnimation(.easeOut(duration: 0.2)) {
                                            self.isTimePickerShow.toggle()
                                            self.setStartAction()
                                        }
                                    }
                                }
                                .opacity(self.isTimePickerShow ? 1: 0)
                                
                                Text(timerDisplay)
                                    .font(.system(size: 38, weight: .semibold))
                                    .monospacedDigit()
                                    .background(.clear)
                                    .foregroundColor(Color("1F2020"))
                                    .italic()
                                    .onTapGesture {
                                        if pomodoroState == .할일_완료 || pomodoroState == .휴식_완료 || pomodoroState == .초기화 {
                                            self.isTimePickerShow.toggle()
                                        } else {
                                            toast = Toast(type: .info, title: "", message: "진행중에는 시간을 변경할 수 없습니다.", position: .top)
                                        }
                                    }
                                    .opacity(self.isTimePickerShow ? 0 : 1)
                            }
                        }
                    }
                }
                .padding(.horizontal, 20)
 
                if pomodoroState == .할일_일시정지 || pomodoroState == .휴식_일시정지 {
                    HStack(spacing: 30) {
                        RoundedButton(leadingImage: Image(systemName: "stop.fill"), title: "정지", action: {
                            dismiss()
                        })

                        RoundedButton(leadingImage: getPomodoroStateImageDisplay(), title: getPomodoroStateDisplay(), action: {
                            setPomodoroStateChange()
                        })
                    }
                    .padding(.bottom, 50)
                } else {
                    RoundedButton(leadingImage: getPomodoroStateImageDisplay(), title: getPomodoroStateDisplay(), action: {
                        if pomodoroState == .할일_완료 {
#if false
                            self.selectedMinute = Int(Config.POMODORO_REST_TIME_MINUTE)
                            self.minuteValue = Int(Config.POMODORO_REST_TIME_MINUTE)
                            self.setStartAction()
#endif
                        } else if pomodoroState == .휴식_완료 {

                            self.setStartAction()
                        }
                        setPomodoroStateChange()
                    })
                    .padding(.bottom, 50)
                }
            }
        }
        .onReceive(minutePassed) { value in
            getSecondTimeToMinuteTime()
#if true
            if value == 0 {
                getTimerForAngle()
            } else {
                self.endPercent -= 0.1
            }
#else
            if value == 0 {
                getTimerForAngle()
            } else {
                if value % 10 == 0 {
                    self.endPercent -= 1
                }
            }
#endif
        }
#if __NOT_USE__
        .onReceive(secondTimer) { _ in
            let elapsedTime: Double = Date().timeIntervalSinceReferenceDate - startTime.timeIntervalSinceReferenceDate
            
            if elapsedTime < Config.POMODORO_TIME_MINUTE {
                self.elapsedTime = elapsedTime
                self.themeColor = Color("1F2020")
            } else {
                self.elapsedTime = 0
                self.startTime = Date()
                self.themeColor = .clear
            }
            
            if elapsedTime >= Config.POMODORO_TIME_MINUTE  {
                self.selectedMinute = self.selectedMinute - 1
                
                if self.selectedMinute < 0 {
                    secondTimer.upstream.connect().cancel()
                }
                getTimerForAngle()
            }
        }
#endif

        .rotation3DEffect(.degrees(showing ? 0 : -180), axis: (x: 1, y: 0, z: 0))
#if __NOT_USE__
        .animation(.spring(duration: 0.3, bounce: 0.7), value: showing)
#else
        .animation(.smooth, value: showing)
#endif
        .onAppear {
            bind()
            setToDoPlayingForColor()
            
            withAnimation(.easeOut(duration: 0.2)) {
                self.setStartAction()
                showing = true
            }
        }
        .toastView(toast: $toast)
        .onDisappear {
            secondTimer.upstream.connect().cancel()
            timerManager.resetTimer()
        }
        .onTapGesture {
            self.endTextEditing()
        }
        .overlay {
            ZStack(alignment: .bottom) {
                Color.black.opacity(0.1).opacity(self.isMenuShow ? 1 : 0)
                    .onTapGesture {
                        self.isMenuShow.toggle()
                    }
                
                if self.isMenuShow {
                    BottomSheetView($isMenuShow, height: 550) {
                        VStack {
                            PomodoroSettingView(focusTime: minuteValue, breakTime: minuteBreakValue, isAlarmStatus: $isAlarmStatus, isFullScreen: $isFullScreen, weekDays: $weekDays, weekDaysList: $weekDaysList)
                        }
                    }
                    .onChange(of: weekDays) { oldValue, newValue in
                        toDoListViewModel.updateToWeekDays(toDoListData: toDoListData, updateWeekDay: newValue)
                    }
                }
            }
        }
        .onReceive(focusTimeSetting) { focusTimeIndex in
            print("focusTimeIndex = \(focusTimeIndex)")
        }
        .onReceive(breakTimeSetting) { breakTimeIndex in
            print("breakTimeIndex = \(breakTimeIndex)")
        }
        .onChange(of: isAlarmStatus) { oldValue, newValue in
        }
        .onChange(of: isFullScreen) { oldValue, newValue in
            getSecondTimeToMinuteTime()
        }
        .onChange(of: scenePhase) { oldValue, newValue in
            print("oldValue = \(oldValue), newValue = \(newValue)")

            if oldValue == .inactive, newValue == .background {
                if (pomodoroState == .할일_진행중 || pomodoroState == .휴식_진행중), self.timeRemaining >  2 {
                    setFinishingTime()
                }
            } else if oldValue == .background, newValue == .inactive {
                guard let savedDate = UserDefaults.standard.object(forKey: Config.TIMEREMAING_SAVE_ID) as? Date else {
                    return
                }
                setDateComponents(savedDate)
            }
        }
    }
    
    func setDateComponents(_ savedDate: Date) {
        let currentDate = Date()
        
        let calendar = Calendar.current
        let components = calendar.dateComponents([.second], from: currentDate, to: savedDate)
        
        if let seconds = components.second {
            if seconds > 0 {
                let minute = seconds / Int(Config.POMODORO_TIME_MINUTE)
                self.minuteValue = minute
                
                let newSecond = seconds.remainderReportingOverflow(dividingBy: Int(Config.POMODORO_TIME_MINUTE)).partialValue
                timerManager.timeRemaining = TimeInterval(Int(Config.POMODORO_TIME_MINUTE) - newSecond)
                
                print("new timerManager.timeRemaining = \(timerManager.timeRemaining), minuteValue = \(self.minuteValue), timeRemaining = \(self.timeRemaining), newSecond = \(newSecond)")
                
            } else {
                self.minuteValue = 0
                timerManager.timeRemaining = 0
                timerManager.resetTimer()
            }
            getSecondTimeToMinuteTime()
        }
    }
    
    func setFinishingTime() {
        let currentDate = Date()
        
        var dateComponents = DateComponents()
        dateComponents.second = Int(self.timeRemaining)
        
        let calendar = Calendar.current
        
        if let newDate = calendar.date(byAdding: dateComponents, to: currentDate) {
            UserDefaults.standard.set(newDate, forKey: Config.TIMEREMAING_SAVE_ID)
        }
    }
    
    func bind(_ initState: Bool = true) {
        self.selectedMinute = toDoListData.selectedMinute
        self.minuteValue = self.selectedMinute
        self.minuteBreakValue = toDoListData.breakMinute
        self.weekDays = toDoListData.setWeekDays
        
        for index in 0..<Config.WEEKDAY_TITLE.count {
            let isSelected: Bool = toDoListViewModel.getSelectWeekDayValue(toDoListData.setWeekDays, weekDay: Config.WEEKDAY_TITLE[index])
            let weekDayItem: WeekDayItem = WeekDayItem(weekDay: Config.WEEKDAY_TITLE[index], isSelected: isSelected)
            self.weekDaysList.insert(weekDayItem, at: index)
        }

        UserDefaults.standard.removeObject(forKey: Config.TIMEREMAING_SAVE_ID)
    }
    
    func setToDoPlayingForColor() {
        var remaining = index % Config.MAIN_STICKER_COUNT
        
        if remaining >= Config.MAIN_STICKER_COUNT {
            remaining = 0
        }
        
        DispatchQueue.main.async {
            color = Color("STICKER_\(remaining)")
        }
    }
    
    func setStartAction() {
        getSecondTimeToMinuteTime()
        getTimerForAngle()
    }
    
    func getTimerForAngle() {

        if self.isFullScreen {
            return
        }

        var startAngle = 360 / (Config.POMODORO_TIME_FULL_COUNT / (Double(minuteValue) * Config.POMODORO_TIME_MINUTE))
        
        if self.minuteValue <= 0 {

            if pomodoroState == .할일_진행중 || pomodoroState == .휴식_진행중 {
                toDoListFinished()
            }

            if pomodoroState == .할일_진행중 {
                pomodoroState = .할일_완료
                timerManager.pauseTimer()
                withAnimation(.easeInOut(duration: 0.2)) {
                    self.endPercent = 360
                }
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                    self.selectedMinute = self.minuteBreakValue
                    self.minuteValue = self.minuteBreakValue
                    self.setStartAction()
                    DispatchQueue.main.async {
                        color = Color(hex: "0xE3EAA7")
                        self.endPercent = 360 / (Config.POMODORO_TIME_FULL_COUNT / (Double(selectedMinute) * Config.POMODORO_TIME_MINUTE))
                    }
                }
                
                return
            } else if pomodoroState == .휴식_진행중 {
                pomodoroState = .휴식_완료
            }
            
            timerManager.pauseTimer()
            self.endPercent = 360
            return
        } else if self.minuteValue == 60, startAngle == 360 {
            startAngle = 0
        }
        
        withAnimation(.easeInOut(duration: 0.2)) {
            self.endPercent = startAngle
        }
    }

    func toDoListFinished() {
        let toDoListCompletion: ToDoListCompletion = ToDoListCompletion()
        toDoListCompletion.updateCompletionToDoData(
            isDone: true,
            date: Date(),
            dateForWeek: Date().weekDay,
            pomodoroState: pomodoroState,
            selectedMinute: pomodoroState == .할일_진행중 ? self.selectedMinute : 0,
            remainingTime : 0,
            breakMinute: pomodoroState == .할일_진행중 ? 0 : self.selectedMinute
        )
            
        toDoListViewModel.addCompletionToDoItem(toDoListData: toDoListData, toDoListCompletion: toDoListCompletion)
    }
    
    func getPomodoroStateImageDisplay() -> Image? {
        switch pomodoroState {
        case .초기화, .휴식_완료, .할일_완료:
            return Image(systemName: "play.fill")
        case .할일_진행중, .휴식_진행중:
            return Image(systemName: "pause.fill")
        case .할일_일시정지, .휴식_일시정지:
            return Image(systemName: "playpause.fill")
        }
    }
    
    func getPomodoroStateDisplay() -> String {
        var stateString: String = "집중 시작하기"
        
        switch pomodoroState {
        case .초기화, .휴식_완료:
            stateString = "집중 시작하기"
        case .할일_진행중, .휴식_진행중:
            stateString = "일시 정지"
        case .할일_완료:
            stateString = "휴식 시작하기"
        case .할일_일시정지, .휴식_일시정지:
            stateString = "계속"
        }
        
        return stateString
    }
    
    func setPomodoroStateChange() {
        let currentPomodoroState: PomodoroState = pomodoroState
        var isResume: Bool = false
        
        if currentPomodoroState == .초기화 {
            pomodoroState = .할일_진행중
        } else if currentPomodoroState == .할일_진행중 {
            pomodoroState = .할일_일시정지
        } else if currentPomodoroState == .할일_완료 {
            pomodoroState = .휴식_진행중
        } else if currentPomodoroState == .휴식_진행중 {
            pomodoroState = .휴식_일시정지
        } else if currentPomodoroState == .할일_일시정지 {
            pomodoroState = .할일_진행중
            isResume = true
        } else if currentPomodoroState == .휴식_일시정지 {
            pomodoroState = .휴식_진행중
            isResume = true
        }
        
        if pomodoroState == .할일_진행중 || pomodoroState == .휴식_진행중 {
            if isResume == false {
                timerManager.startTimer()
            } else {
                timerManager.resumeTimer()
            }
            
            NotificationManager.instance.scheduleNotification(title: pomodoroState == .할일_진행중 ? "집중 시간" : "휴식 시간", body: toDoListData.messageText, timeInterval: self.timeRemaining, triggerType: .time)
            
        } else if pomodoroState == .할일_일시정지 || pomodoroState == .휴식_일시정지 {
            timerManager.pauseTimer()
            NotificationManager.instance.cancelNotification()
        }
    }
    
    func getSecondTimeToMinuteTime() {
        var secondValue: Int = Int(Config.POMODORO_TIME_MINUTE) - Int(timerManager.timeRemaining)
        
        if secondValue == Int(Config.POMODORO_TIME_MINUTE) {
            secondValue = 0
        } else if secondValue == Int(Config.POMODORO_TIME_MINUTE) - 1 {
            self.minuteValue -= 1
            
            if self.minuteValue < 0 {
                self.minuteValue = 0
            }
        }
        
        self.timeRemaining = Double(minuteValue) * Config.POMODORO_TIME_MINUTE + Double(secondValue)
        
        DispatchQueue.main.async {
            if self.isFullScreen {
                timerDisplay = String(format: "%02d\n%02d", minuteValue, secondValue)
            } else {
                timerDisplay = String(format: "%02d:%02d", minuteValue, secondValue)
            }
        }
    }
}
