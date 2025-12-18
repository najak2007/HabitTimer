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
    
    func onLiveActivity(activityTitle: String, backgroundIndex: Int, activityStatus: PomodoroState, remaingTime: Int, currentDate: Date = Date(), remaingDate: Date = Date()) {
        guard ActivityAuthorizationInfo().areActivitiesEnabled else { return }
        
        let attributes = TimeWidgetAttributes(
            title: activityTitle,
            backgroundIndex: backgroundIndex,
            pomodoroState: activityStatus,
        )
        
        let state = TimeWidgetAttributes.ContentState(remaingTime: remaingTime, currentDate: currentDate, remaingDate: remaingDate)
        let content = ActivityContent(state: state, staleDate: remaingDate, relevanceScore: 1.0)
        
        do {
            self.activity = try Activity.request(attributes: attributes, content: content)
        } catch {
            
        }
    }
    
    @objc func offLiveActivity(staleDate: Date? = nil) {
        Task {
            await activity?.end(nil, dismissalPolicy: .immediate)
        }
    }
    
    func updateLiveActivity(remaingTime: Int, currentDate: Date = Date(), remaingDate: Date = Date()) {

        let state = TimeWidgetAttributes.ContentState(remaingTime: remaingTime, currentDate: currentDate, remaingDate: remaingDate)
        let newContent = ActivityContent(state: state, staleDate: remaingDate, relevanceScore: 1.0)
#if __NOT_USE__
        Task {
            if remaingTime > 0 {
                await self.activity?.update(newContent)
            } else {
                self.offLiveActivity()
            }
        }
#else
        
        
#endif
    }
}
