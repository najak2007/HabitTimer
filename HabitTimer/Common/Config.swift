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
    static let INPUT_VIEW_HEADER_FONT_SIZE: CGFloat = 14
    
    static let POMODORO_TIME_MINUTE: Double = 60
    static let POMODORO_TIME_DEFAULT_COUNT: Double = 25 * Config.POMODORO_TIME_MINUTE
    static let POMODORO_TIME_FULL_COUNT: Double = 60 * Config.POMODORO_TIME_MINUTE
    
    static let TODOLIST_ROW_HEIGHT: CGFloat = 340
    
    static let POMODORO_WORK_TIME_MINUTE: Double = 2 //25
    
    static let POMODORO_REST_TIME_MINUTE: Double = 5
    
    static let TODO_BUBBLE_WIDTH: CGFloat = 300
    
    static let TEXTVIEW_SHOW_ANIMATION_INTERVAL: CGFloat = 0.5
    static let INPUT_TEXT_COUNT_LIMIT: Int = 80
    
    static let INPUT_TEXT_FIELD_DEFAULT_HEIGHT: CGFloat = 40
    static let INPUT_TEXT_FIELD_MAX_HEIGHT: CGFloat = 100
    static let INPUT_TEXT_FIELD_MARGIN: CGFloat = 25
    
    static let MAIN_STICKER_COUNT: Int = 5
}
