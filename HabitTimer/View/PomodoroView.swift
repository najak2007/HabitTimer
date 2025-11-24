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
    @State private var minuteBreakValue: Int = Config.POMODORO_REST_TIME_MINUTE
    @State private var pomodoroState: PomodoroState = .초기화
    @State private var timerDisplay: String = "00:00"
    @State private var toast: Toast? = nil
    @State private var isDoneButtonShow: Bool = false
    @State private var isTimePickerShow: Bool = false
    @State private var isMenuShow: Bool = false
    @State private var isAutoStart: Bool = false       // 자동으로 휴식 설정
    @State private var isFullScreen: Bool = false
    
    var toDoListViewModel: ToDoListViewModel
    @Binding var toDoListData: ToDoListData
    @Binding var isDetailShow: Bool
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
                            VStack(alignment: .center) {
                                
                                Spacer()
                                
                                Text(timerDisplay)
                                    .font(.system(size: 250, weight: .semibold))
                                    .multilineTextAlignment(.center)
                                    .lineLimit(2)
                                    .monospacedDigit()
                                    .background(.clear)
                                    .foregroundColor(Color("1F2020"))
                                    .italic()
                                    .frame(maxWidth: .infinity)
                                    .onTapGesture {
                                        if pomodoroState == .할일_완료 || pomodoroState == .휴식_완료 || pomodoroState == .초기화 {
                                            self.isTimePickerShow.toggle()
                                        } else {
                                            toast = Toast(type: .info, title: "", message: "현재 상태에서는 시간을 변경할 수 없습니다.", position: .top)
                                        }
                                    }
                                    .opacity(self.isTimePickerShow ? 0 : 1)
                                
                                Spacer()
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
                                            toast = Toast(type: .info, title: "", message: "현재 상태에서는 시간을 변경할 수 없습니다.", position: .top)
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
                        RoundedButton(leadingImage: getPomodoroStateImageDisplay(), title: getPomodoroStateDisplay(), action: {
                            setPomodoroStateChange()
                        })
                        
                        RoundedButton(leadingImage: Image(systemName: "stop.fill"), title: "정지", action: {
                            dismiss()
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
            
            print("self.endPercent = \(self.endPercent)")
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
            
            setToDoPlayingForColor()
            
            withAnimation(.easeOut(duration: 0.2)) {
                self.setStartAction()
                showing = true
            }
        }
        .toastView(toast: $toast)
        .onDisappear {
            secondTimer.upstream.connect().cancel()
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
                    BottomSheetView($isMenuShow, height: 450) {            /* 550  ---> 점수 모드 포함했을 경우에 height == 550 으로 한다. - Section 의 높이 */
                        VStack {
                            PomodoroSettingView(focusTime: minuteValue, breakTime: minuteBreakValue, isAutoStart: $isAutoStart, isFullScreen: $isFullScreen)
                        }
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
        .onChange(of: isAutoStart) { oldValue, newValue in
            
        }
        .onChange(of: isFullScreen) { oldValue, newValue in
            getSecondTimeToMinuteTime()
        }
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
        var startAngle = 360 / (Config.POMODORO_TIME_FULL_COUNT / (Double(minuteValue) * Config.POMODORO_TIME_MINUTE))
        
        print("뽀모도로 시계 각도(startAngle) = \(startAngle), minuteValue = \(minuteValue)")
        
        if self.minuteValue <= 0 {
            if pomodoroState == .할일_진행중 {
                pomodoroState = .할일_완료
                timerManager.pauseTimer()
                
                withAnimation(.easeInOut(duration: 0.2)) {
                    self.endPercent = 360
                }
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                    self.selectedMinute = Config.POMODORO_REST_TIME_MINUTE
                    self.minuteValue = Config.POMODORO_REST_TIME_MINUTE
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
                timerManager.resetTimer()
            }
        } else if pomodoroState == .할일_일시정지 || pomodoroState == .휴식_일시정지 {
            timerManager.pauseTimer()
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
        
        DispatchQueue.main.async {
            if self.isFullScreen {
                timerDisplay = String(format: "%02d\n%02d", minuteValue, secondValue)
            } else {
                timerDisplay = String(format: "%02d:%02d", minuteValue, secondValue)
            }
        }
    }
}
