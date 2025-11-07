//
//  TimerManager.swift
//  HabitTimer
//
//  Created by najak on 11/7/25.
//

import SwiftUI
import Combine

class TimerManager: ObservableObject {
    @Published var timeRemaining: Double = Config.POMODORO_TIME_MINUTE
    @Published var isPaused: Bool = true
    private var timer: Timer?
    
    func startTimer() {
        if timer == nil {
            timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
                guard let self = self else { return }
                
                if self.timeRemaining > 0 {
                    self.timeRemaining -= 1
                } else {
                    self.timer?.invalidate()
                    self.timer = nil
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
        timeRemaining = Config.POMODORO_DEFAULT_MINUTE
        isPaused = true
    }
}
