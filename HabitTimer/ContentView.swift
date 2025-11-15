//
//  ContentView.swift
//  HabitTimer
//
//  Created by 오션블루 on 11/4/25.
//

import SwiftUI
import Combine

struct ContentView: View {
    private let timer = Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()
    private let startTime: Date = Date()
    private let endTime: Double = 10
    
    @State private var elapsedTime: Double = 0.0
    @State private var isPomodoroTimer: Bool = false
    @State private var isBubbleView: Bool = false
    
    // UI Config
    private let themeColor: Color = Color(red: 252/255, green: 95/255, blue: 163/255)
    private let circlePadding: CGFloat = 30
    
    var body: some View {
        NavigationView {
            VStack {
                Circle()
                    .strokeBorder(lineWidth: 24)
                    .overlay {
                        Circle()
                            .trim(from: 0.0, to: elapsedTime/endTime)
                            .stroke(themeColor, style: StrokeStyle(lineWidth: 24.0, lineCap: .round, lineJoin: .round))
                            .rotationEffect(Angle(degrees: 270))
                            .animation(.easeInOut(duration: 1.0), value: elapsedTime)
                            .padding(12)
                    }
                    .padding(circlePadding)
                
                Button(action: {
                    self.isPomodoroTimer.toggle()
                }, label: {
                    Text("Pomodoro View")
                })
                
                Button(action: {
                    self.isBubbleView.toggle()
                }, label: {
                    Text("Bubble Example")
                })
            }
        }
        .onReceive(timer) { _ in
            let elapsedTime = Date().timeIntervalSinceReferenceDate - startTime.timeIntervalSinceReferenceDate
            if elapsedTime < endTime {
                self.elapsedTime = elapsedTime
            } else  {
                self.elapsedTime = endTime
            }
        }
        .onDisappear {
            timer.upstream.connect().cancel()
        }
        .fullScreenCover(isPresented: $isPomodoroTimer, onDismiss: {
            
        }) {
            PomodoroView()
        }
        .fullScreenCover(isPresented: $isBubbleView, onDismiss: {
            
        }) {
            ToDoListView()
        }
        
    }
}
