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
    @State private var themeColor: Color = Color("1F2020")
    
    @State private var startTime: Date = Date()
    @State private var endTime: Double = Config.POMODORO_TIME_DEFAULT_COUNT
    
    @State private var startPercent: CGFloat = 0
    @State private var endPercent: CGFloat = 360
    @State private var color: Color = .red
    @State private var backgroundColor: Color = .black
    @State private var elapsedTime: Double = 0.0
    
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
                            .strokeBorder(lineWidth: 2)
                            .foregroundColor(self.color)
                            .overlay {
                                Circle()
                                    .trim(from: 0.0, to: elapsedTime/Config.POMODORO_TIME_MINUTE)
                                    .stroke(themeColor, style: StrokeStyle(lineWidth: 4.0, lineCap: .round, lineJoin: .round))
                                    .rotationEffect(Angle(degrees: 270))
                                    .animation(.easeInOut(duration: self.elapsedTime == 0 ? 0.0 : 1.0), value: elapsedTime)
                                    .padding(2)
                                    
                            }
                    }
                }
            }
        }
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
                getTimerForAngle(elapsedTime: elapsedTime)
            }
        }
        .onDisappear {
            secondTimer.upstream.connect().cancel()
        }
        
    }
    
    func getTimerForAngle(elapsedTime: Double) {
        let startAngle = 360 / (Config.POMODORO_TIME_FULL_COUNT / endTime)
        
        print("getTimerForAngle = \(startAngle)")
        
        self.endPercent = startAngle
    }
}
