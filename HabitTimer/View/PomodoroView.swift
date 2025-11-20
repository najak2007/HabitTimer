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
 //   @StateObject private var toDoListViewModel = ToDoListViewModel()
    
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
    @State private var pomodoroState: PomodoroState = .초기화
    @State private var timerDisplay: String = "00:00"
    @State private var toast: Toast? = nil
    @State private var isDoneButtonShow: Bool = false
    @State private var isTimePickerShow: Bool = false
    
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
                        toDoListViewModel.updateToDoMessageText(toDoListData: toDoListData, messageText: messageText)
                    }, label: {
                        Image(systemName: "checkmark.circle.fill")
                            .resizable()
                            .frame(width: 35, height: 35)
                            .foregroundColor(Color("1F2020"))
                    })
                    .opacity(isDoneButtonShow ? 1 : 0)
                }
                .frame(height: Config.NAVIGATION_HEIGHT)
                .padding(.horizontal, 20)
                .onAppear {
                    self.messageText = self.toDoListData.messageText
                }
                
                
                GeometryReader { geometryProxy in
                    ZStack(alignment: .center) {
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
                            .strokeBorder(self.color, lineWidth: 2)
                            .overlay {
                                Circle()
                                    .trim(from: 0.0, to: timerManager.timeRemaining/Config.POMODORO_TIME_MINUTE)
                                    .stroke(themeColor, style: StrokeStyle(lineWidth: 4.0, lineCap: .round, lineJoin: .round))
                                    .rotationEffect(Angle(degrees: 270))
                                    .animation(.smooth(duration: timerManager.timeRemaining == 0 ? 0.0 : 1.0), value: timerManager.timeRemaining)
                                    .padding(2)
                                    
                                
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
                                withAnimation(.easeOut(duration: 0.2)) {
                                    self.isTimePickerShow.toggle()
                                    self.setStartAction()
                                }
                            }
                            .opacity(self.isTimePickerShow ? 1: 0)
                            
                            Text(timerDisplay)
                                .font(.system(size: 38, weight: .semibold))
                                .monospacedDigit()
                                .foregroundColor(Color("1F2020"))
                                .italic()
                                .onTapGesture {
                                    self.isTimePickerShow.toggle()
                                }
                                .opacity(self.isTimePickerShow ? 0 : 1)
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
                            self.selectedMinute = Int(Config.POMODORO_REST_TIME_MINUTE)
                            self.minuteValue = Int(Config.POMODORO_REST_TIME_MINUTE)
                            self.setStartAction()
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
            if value {
                getTimerForAngle()
            }
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
            
            var remaining = index % Config.MAIN_STICKER_COUNT
            
            if remaining >= Config.MAIN_STICKER_COUNT {
                remaining = 0
            }
            color = Color("STICKER_\(remaining)")
            
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
    }
    
    func setStartAction() {
        getSecondTimeToMinuteTime()
        getTimerForAngle()
    }
    
    func getTimerForAngle() {
        var startAngle = 360 / (Config.POMODORO_TIME_FULL_COUNT / (Double(minuteValue) * Config.POMODORO_TIME_MINUTE))
        
        if self.minuteValue <= 0 {
            if pomodoroState == .할일_진행중 {
                pomodoroState = .할일_완료
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
            timerDisplay = String(format: "%02d:%02d", minuteValue, secondValue)
        }
    }
}
