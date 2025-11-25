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

enum PomodoroState: Decodable, Encodable {
    case 초기화
    case 할일_진행중
    case 할일_일시정지
    case 할일_완료
    case 휴식_진행중
    case 휴식_일시정지
    case 휴식_완료
}

class ToDoListCompletion: Object, Comparable {
    @objc dynamic var date: Date = Date()
    @objc dynamic var isDone: Bool = false
    dynamic var pomodoroState: PomodoroState = .초기화
    @objc dynamic var selectedMinute: Int = Config.POMODORO_WORK_TIME_MINUTE
    @objc dynamic var remainingMinute: Int = Config.POMODORO_WORK_TIME_MINUTE
    @objc dynamic var breakMinute: Int = Config.POMODORO_BREAK_TIME_MINUTE
    
    static func < (lhs: ToDoListCompletion, rhs: ToDoListCompletion) -> Bool {
        return lhs.date < rhs.date
    }
}

final class ToDoListData: Object, Comparable {
    @objc dynamic var id: String = Date().toDoListID
    @objc dynamic var isFromYou: Bool = false
    @objc dynamic var messageText: String = ""
    @objc dynamic var createDate: Date = Date()
    
#if __NOT_USE__
    @objc dynamic var isDone: Bool = false
    @objc dynamic var isRepeat: Bool = false
    @objc dynamic var placeName: String = ""
    @objc dynamic var remainingTime: Int = 0
#else
    @objc dynamic var selectedMinute: Int = Config.POMODORO_WORK_TIME_MINUTE
    @objc dynamic var breakMinute: Int = Config.POMODORO_BREAK_TIME_MINUTE
    dynamic var toDoListItems: List<ToDoListCompletion> = List<ToDoListCompletion>()
#endif
    static func < (lhs: ToDoListData, rhs: ToDoListData) -> Bool {
        return lhs.createDate < rhs.createDate
    }
    
    
    func setMessageText(messageText: String, isFromYou: Bool = true) {
        self.messageText = messageText
        self.isFromYou = isFromYou
    }
}
