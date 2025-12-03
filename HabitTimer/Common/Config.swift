//
//  Untitled.swift
//  HabitTimer
//
//  Created by najak on 11/6/25.
//

import Foundation

enum InputTypeError {
    case 할일_미입력
    case 할일_글자수_초과
}



class Config {
    static let NAVIGATION_HEIGHT: CGFloat = 80
    static let MAIN_HEADER_TITLE_FONT_SIZE: CGFloat = 18
    static let SUB_HEADER_TITLE_FONT_SIZE: CGFloat = 14
    
    static let INPUT_VIEW_HEADER_FONT_SIZE: CGFloat = 14
    
    static let POMODORO_TIME_MINUTE: Double = 60
    static let POMODORO_TIME_DEFAULT_COUNT: Double = 25 * Config.POMODORO_TIME_MINUTE
    static let POMODORO_TIME_FULL_COUNT: Double = 60 * Config.POMODORO_TIME_MINUTE
    
    static let TODOLIST_ROW_HEIGHT: CGFloat = 340
    
    static let POMODORO_WORK_TIME_MINUTE: Int = 3 //25
    
    static let POMODORO_BREAK_TIME_MINUTE: Int = 5
    
    static let TODO_BUBBLE_WIDTH: CGFloat = 300
    
    static let TEXTVIEW_SHOW_ANIMATION_INTERVAL: CGFloat = 0.5
    static let INPUT_TEXT_COUNT_LIMIT: Int = 80
    
    static let INPUT_TEXT_FIELD_DEFAULT_HEIGHT: CGFloat = 40
    static let INPUT_TEXT_FIELD_MAX_HEIGHT: CGFloat = 100
    static let INPUT_TEXT_FIELD_MARGIN: CGFloat = 25
    
    static let MAIN_STICKER_COUNT: Int = 5
    
    static let TIME_CIRCLE_ROUND_WIDTH: CGFloat = 8.0
    
    static let NOTIFICATION_SETTING_ID: String = "habitTimer.notification.setting"
    static let TIMEREMAING_SAVE_ID: String = "habitTimer.timerRemaining.save"
    
    static let WEEKDAY_TITLE: [String] = ["일", "월", "화", "수", "목", "금", "토"]
    static let CALENDAR_START_YEAR: Int = 2025
    static let SEGMENTED_CONTROL_STYLE_FONT_SIZE: CGFloat = 18
}
