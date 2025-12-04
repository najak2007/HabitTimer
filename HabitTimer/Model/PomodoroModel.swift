//
//  PomodoroModel.swift
//  HabitTimer
//
//  Created by najak on 11/7/25.
//

import Foundation
import Combine
import RealmSwift

var minutePassed = PassthroughSubject<Int, Never>()

var pomodoroStartMode = PassthroughSubject<Bool, Never>()

var focusTimeSetting = PassthroughSubject<Int, Never>()
var breakTimeSetting = PassthroughSubject<Int, Never>()

enum PomodoroState: Int, Decodable, Encodable {
    case 초기화
    case 할일_진행중
    case 할일_일시정지
    case 할일_완료
    case 휴식_진행중
    case 휴식_일시정지
    case 휴식_완료
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

enum WeekDayValue: Int {
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

class ToDoListCompletion: Object, Comparable {
    @objc dynamic var date: Date = Date()
    @objc dynamic var dateForWeek: String = Date().weekDay
    @objc dynamic var isDone: Bool = false
    dynamic var pomodoroState: Int = PomodoroState.초기화.rawValue
    @objc dynamic var selectedMinute: Int = Config.POMODORO_WORK_TIME_MINUTE
    @objc dynamic var remainingMinute: Int = Config.POMODORO_WORK_TIME_MINUTE
    @objc dynamic var breakMinute: Int = Config.POMODORO_BREAK_TIME_MINUTE

    
    static func < (lhs: ToDoListCompletion, rhs: ToDoListCompletion) -> Bool {
        return lhs.date < rhs.date
    }
    
    func updateCompletionToDoData(isDone: Bool, date: Date = Date(), dateForWeek: String, pomodoroState: PomodoroState, selectedMinute: Int, remainingTime: Int, breakMinute: Int) {
        self.isDone = isDone
        self.date = date
        self.dateForWeek = dateForWeek
        self.pomodoroState = pomodoroState == .할일_진행중 ? PomodoroState.할일_완료.rawValue : PomodoroState.휴식_완료.rawValue
        self.selectedMinute = selectedMinute
        self.remainingMinute = remainingTime
        self.breakMinute = breakMinute
    }
}

final class ToDoListData: Object, Comparable {
    @objc dynamic var id: String = Date().toDoListID
    @objc dynamic var isFromYou: Bool = false
    @objc dynamic var messageText: String = ""
    @objc dynamic var createDate: Date = Date()
    @objc dynamic var createDateForWeek: String =  Date().weekDay
    
#if __NOT_USE__
    @objc dynamic var isDone: Bool = false
    @objc dynamic var isRepeat: Bool = false
    @objc dynamic var placeName: String = ""
    @objc dynamic var remainingTime: Int = 0
#else
    @objc dynamic var selectedMinute: Int = Config.POMODORO_WORK_TIME_MINUTE
    @objc dynamic var breakMinute: Int = Config.POMODORO_BREAK_TIME_MINUTE
    dynamic var toDoListItems: List<ToDoListCompletion> = List<ToDoListCompletion>()
    @objc dynamic var setWeekDays: Int = 0x000
#endif
    static func < (lhs: ToDoListData, rhs: ToDoListData) -> Bool {
        return lhs.createDate < rhs.createDate
    }
    
    
    func setMessageText(messageText: String, isFromYou: Bool = true) {
        self.messageText = messageText
        self.isFromYou = isFromYou
        self.setWeekDays = WeekDayValue.getWeekDayForDate(Date())
    }
}
