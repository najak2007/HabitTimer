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
    @State private var backgroundColor: Color = .black
    @State private var elapsedTime: Double = 0.0
    @State private var selectedMinute: Double = Config.POMODORO_DEFAULT_MINUTE
    @State private var pomodoroState: PomodoroState = .초기화
    
    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    Spacer()
                    
                    Button(action: {
                        dismiss()
                    }, label: {
                        Image(systemName: "xmark.circle.fill")
                            .resizable()
                            .frame(width: 35, height: 35)
                            .foregroundColor(Color("1F2020"))
                    })
                }
                .frame(height: Config.NAVIGATION_HEIGHT)
                .padding(.horizontal, 20)
                
                
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
                                    .trim(from: 0.0, to: elapsedTime/Config.POMODORO_TIME_MINUTE)
                                    .stroke(themeColor, style: StrokeStyle(lineWidth: 4.0, lineCap: .round, lineJoin: .round))
                                    .rotationEffect(Angle(degrees: 270))
                                    .animation(.easeInOut(duration: self.elapsedTime == 0 ? 0.0 : 1.0), value: timerManager.timeRemaining)
                                    .padding(2)
                                
                            }
                    }
                }
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
                        setPomodoroStateChange()
                    })
                    .padding(.bottom, 50)
                }
            }
        }
//        .onReceive(secondTimer) { _ in
//            let elapsedTime: Double = Date().timeIntervalSinceReferenceDate - startTime.timeIntervalSinceReferenceDate
//            
//            if elapsedTime < Config.POMODORO_TIME_MINUTE {
//                self.elapsedTime = elapsedTime
//                self.themeColor = Color("1F2020")
//            } else {
//                self.elapsedTime = 0
//                self.startTime = Date()
//                self.themeColor = .clear
//            }
//            
//            if elapsedTime >= Config.POMODORO_TIME_MINUTE  {
//                self.selectedMinute = self.selectedMinute - 1
//                
//                if self.selectedMinute < 0 {
//                    secondTimer.upstream.connect().cancel()
//                }
//                getTimerForAngle()
//            }
//        }
        .onDisappear {
            secondTimer.upstream.connect().cancel()
        }
        .onAppear {
            getTimerForAngle()
        }
    }
    
    func getTimerForAngle() {
        let startAngle = 360 / (Config.POMODORO_TIME_FULL_COUNT / (selectedMinute * Config.POMODORO_TIME_MINUTE))
        
        print("getTimerForAngle = \(startAngle)")
        
        self.endPercent = startAngle
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
}
