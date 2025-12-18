//
//  TimerManager.swift
//  HabitTimer
//
//  Created by najak on 11/7/25.
//

import SwiftUI
import Combine
import UIKit

class TimerManager: ObservableObject {
    @Published var timeRemaining: Double = 0
    @Published var isPaused: Bool = true
    @Published var isStart: Bool = false
    private var timer: Timer?
    private var midnightTimer: Timer?
    
    func startTimer() {
        if timer == nil {
            
            UIApplication.shared.isIdleTimerDisabled = true
            
            timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
                guard let self = self else { return }
                
                self.timeRemaining += 1
                if self.timeRemaining >= Config.POMODORO_TIME_MINUTE {
                    self.timeRemaining = 0
                }
                minutePassed.send(Int(self.timeRemaining))
                
                if isStart == false {
                    activeLiveShowPassed.send(true)
                }
                isStart = true
            }
            isPaused = false
        }
    }
    
    func pauseTimer() {
        timer?.invalidate()
        timer = nil
        isPaused = true
        isStart = false
        
        activeLiveShowPassed.send(false)
        
        UIApplication.shared.isIdleTimerDisabled = false
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
        isStart = false
        
        UIApplication.shared.isIdleTimerDisabled = false
    }
    
    func midnightCheckTimer() {
        if midnightTimer == nil {
            guard let timeRemaingInterval = CalendarViewModel.timeRemainingUntilMidnight() else {
                return
            }

            midnightTimer = Timer.scheduledTimer(withTimeInterval: Double(timeRemaingInterval), repeats: false) { _ in
                midnightPassed.send()
            }
        }
    }
    
    func midnightResetTimer() {
        midnightTimer?.invalidate()
        midnightTimer = nil
    }
}
