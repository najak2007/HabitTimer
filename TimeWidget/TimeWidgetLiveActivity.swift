//
//  TimeWidgetLiveActivity.swift
//  TimeWidget
//
//  Created by najak on 12/14/25.
//

import ActivityKit
import WidgetKit
import SwiftUI

struct TimeWidgetAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        // Dynamic stateful properties about your activity go here!
        var remaingTime: Int
    }

    // Fixed non-changing properties about your activity go here!
    var title: String
    var backgroundIndex: Int
    var pomodoroState: PomodoroState
    
}

struct TimeWidgetLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: TimeWidgetAttributes.self) { context in
            // Lock screen/banner UI goes here
            VStack(spacing: 10) {
                Text(context.attributes.title)
                    .font(.custom("GmarketSansTTFMedium", size: Config.LIVE_ACTIVITY_TITLE_FONT_SIZE))
                    .foregroundColor(.black)
             
                HStack {
                    Text((context.attributes.pomodoroState == .할일_진행중 || context.attributes.pomodoroState == .할일_일시정지) ? "집중 시간" : "휴식 시간")
                        .font(.custom("GmarketSansTTFMedium", size: Config.LIVE_ACTIVITY_POMODORO_FONT_SIZE))
                        .foregroundColor(.black)
                    
                    VStack {
                        Text(activityTimeConfiguration(for: context.state.remaingTime))
                            .font(.system(size: 24, weight: .semibold))
                            .monospacedDigit()
                            .foregroundColor(.black)
                            .italic()
                    }
                }
            }
            .activityBackgroundTint(setBackgroundColor(for: context.attributes.backgroundIndex))
            .activitySystemActionForegroundColor(Color.black)

        } dynamicIsland: { context in
            DynamicIsland {
                // Expanded UI goes here.  Compose the expanded UI through
                // various regions, like leading/trailing/center/bottom
                DynamicIslandExpandedRegion(.leading) {
                    Text((context.attributes.pomodoroState == .할일_진행중 || context.attributes.pomodoroState == .할일_일시정지) ? "집중" : "휴식")
                }
                DynamicIslandExpandedRegion(.trailing) {
                    Text((context.attributes.pomodoroState == .할일_진행중 || context.attributes.pomodoroState == .휴식_진행중) ? "진행중" : "일시정지" )
                }
                DynamicIslandExpandedRegion(.bottom) {
                    Text("남은 시간: \(activityTimeConfiguration(for: context.state.remaingTime))")
                }
            } compactLeading: {
                Text((context.attributes.pomodoroState == .할일_진행중 || context.attributes.pomodoroState == .할일_일시정지) ? "집중" : "휴식")
            } compactTrailing: {
                Text(activityTimeConfiguration(for: context.state.remaingTime))
            } minimal: {
                Text(activityTimeConfiguration(for: context.state.remaingTime))
            }
            .keylineTint(Color.red)
        }
    }
    
    func setBackgroundColor(for index: Int) -> Color {
        var remaining = index % Config.MAIN_STICKER_COUNT
        
        if remaining >= Config.MAIN_STICKER_COUNT {
            remaining = 0
        }
        
        return Color("STICKER_\(remaining)")
    }
    
    func activityTimeConfiguration(for remainingSecondTime: Int) -> String {
        var minute: String = "00"
        var second: String = "00"
        
        minute = String(format: "%02d", remainingSecondTime / 60)
        second = String(format: "%02d", remainingSecondTime.remainderReportingOverflow(dividingBy: 60).partialValue)
        
        return "\(minute):\(second)"
    }
}

extension TimeWidgetAttributes {
    fileprivate static var preview: TimeWidgetAttributes {
        TimeWidgetAttributes(title: "집중 시간", backgroundIndex: 0, pomodoroState: .할일_진행중)
    }
}

extension TimeWidgetAttributes.ContentState {
    fileprivate static var smiley: TimeWidgetAttributes.ContentState {
        TimeWidgetAttributes.ContentState(remaingTime: 0)
     }
     
     fileprivate static var starEyes: TimeWidgetAttributes.ContentState {
         TimeWidgetAttributes.ContentState(remaingTime: 0)
     }
}
