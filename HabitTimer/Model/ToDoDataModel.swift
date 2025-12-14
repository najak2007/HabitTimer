//
//  ToDoDataModel.swift
//  HabitTimer
//
//  Created by najak on 12/14/25.
//

import SwiftUI
import Combine
import Foundation

enum PomodoroState: Int, Decodable, Encodable {
    case 초기화
    case 할일_진행중
    case 할일_일시정지
    case 할일_완료
    case 휴식_진행중
    case 휴식_일시정지
    case 휴식_완료
    case 휴식_건너뛰기
}

enum WeekDayExpireDate: String {
    case 주말
    case 주중
    case 매일
}

struct WeekDayItem: Identifiable {
    var id: String = UUID().uuidString
    var weekDay: String
    var isSelected: Bool = false
}

enum WeekDayValue: Int, CaseIterable {
    case 한번 = 0x0000
    case 일 = 0x0001
    case 월 = 0x0002
    case 화 = 0x0004
    case 수 = 0x0008
    case 목 = 0x0010
    case 금 = 0x0020
    case 토 = 0x0040
    
    static func getWeekDayForDate(_ date: Date) -> Int {
        let weekDayInt = Calendar.current.component(.weekday, from: date)
        
        switch weekDayInt {
        case 1:
            return WeekDayValue.일.rawValue
        case 2:
            return WeekDayValue.월.rawValue
        case 3:
            return WeekDayValue.화.rawValue
        case 4:
            return WeekDayValue.수.rawValue
        case 5:
            return WeekDayValue.목.rawValue
        case 6:
            return WeekDayValue.금.rawValue
        case 7:
            return WeekDayValue.토.rawValue
        default:
            return 0x0000
        }
    }
    
    static func getWeekDayCaseToString(_ weekDayValue: Int) -> String {
        switch weekDayValue {
        case WeekDayValue.일.rawValue:
            return "일"
        case WeekDayValue.월.rawValue:
            return "월"
        case WeekDayValue.화.rawValue:
            return "화"
        case WeekDayValue.수.rawValue:
            return "수"
        case WeekDayValue.목.rawValue:
            return "목"
        case WeekDayValue.금.rawValue:
            return "금"
        case WeekDayValue.토.rawValue:
            return "토"
        default:
            return ""
        }
    }
    
    static func getWeekDayForString(_ weekDayStr: String) -> Int {
        switch weekDayStr {
        case "일":
            return WeekDayValue.일.rawValue
        case "월":
            return WeekDayValue.월.rawValue
        case "화":
            return WeekDayValue.화.rawValue
        case "수":
            return WeekDayValue.수.rawValue
        case "목":
            return WeekDayValue.목.rawValue
        case "금":
            return WeekDayValue.금.rawValue
        case "토":
            return WeekDayValue.토.rawValue
        default:
            return 0x0000
        }
    }
}
