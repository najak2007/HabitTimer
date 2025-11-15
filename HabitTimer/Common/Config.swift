//
//  Untitled.swift
//  HabitTimer
//
//  Created by najak on 11/6/25.
//

import Foundation

class Config {
    static let NAVIGATION_HEIGHT: CGFloat = 80
    static let INPUT_VIEW_HEADER_FONT_SIZE: CGFloat = 14
    
    static let POMODORO_TIME_MINUTE: Double = 60
    static let POMODORO_TIME_DEFAULT_COUNT: Double = 25 * Config.POMODORO_TIME_MINUTE
    static let POMODORO_TIME_FULL_COUNT: Double = 60 * Config.POMODORO_TIME_MINUTE
    
    static let POMODORO_WORK_TIME_MINUTE: Double = 2 //25
    
    static let POMODORO_REST_TIME_MINUTE: Double = 5
    
    static let TODO_BUBBLE_WIDTH: CGFloat = 300
    
    static let TEXTVIEW_SHOW_ANIMATION_INTERVAL: CGFloat = 0.5
}
