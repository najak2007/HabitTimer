//
//  TimeLiveActivityManager.swift
//  HabitTimer
//
//  Created by najak on 12/14/25.
//

import Foundation
import ActivityKit

@objc class TimeLiveActivityManager: NSObject {
    private var activity: Activity<TimeWidgetAttributes>?
    @objc static let shared = TimeLiveActivityManager()
    
    private init(activity: Activity<TimeWidgetAttributes>? = nil) {
        self.activity = activity
    }
    
    func onLiveActivity(activityTitle: String, backgroundIndex: Int, activityStatus: PomodoroState, remaingTime: Int) {
        guard ActivityAuthorizationInfo().areActivitiesEnabled else { return }
        
        let attributes = TimeWidgetAttributes(
            title: activityTitle,
            backgroundIndex: backgroundIndex,
            pomodoroState: activityStatus,
        )
        let state = TimeWidgetAttributes.ContentState(remaingTime: remaingTime)
        
        do {
            self.activity = try Activity.request(attributes: attributes, contentState: state)
        } catch {
            
        }
    }
    
    @objc func offLiveActivity() {
        Task {
            await activity?.end(using: nil, dismissalPolicy: .immediate)
        }
    }
    
    func updateLiveActivity(remaingTime: Int) {
        Task {
            let newState = TimeWidgetAttributes.ContentState(remaingTime: remaingTime)
            await self.activity?.update(using: newState)
        }
    }
}
