//
//  TimerManager.swift
//  HabitTimer
//
//  Created by najak on 11/7/25.
//

import SwiftUI
import Combine

class TimerManager: ObservableObject {
    @Published var timeRemaining: Double = 0
    @Published var isPaused: Bool = true
    private var timer: Timer?
    
    func startTimer() {
        if timer == nil {
            timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
                guard let self = self else { return }
                
                self.timeRemaining += 1
                if self.timeRemaining >= Config.POMODORO_TIME_MINUTE {
                    self.timeRemaining = 0
                    minutePassed.send(true)     // Void로 하면 .send() 로 해도 된다.
                } else {
                    minutePassed.send(false)
                }
            }
            isPaused = false
        }
    }
    
    func pauseTimer() {
        timer?.invalidate()
        timer = nil
        isPaused = true
    }
    
    func resumeTimer() {
        if isPaused && timeRemaining > 0 {
            startTimer()
        }
    }
    
    func resetTimer() {
        timer?.invalidate()
        timer = nil
        isPaused = true
    }
}
