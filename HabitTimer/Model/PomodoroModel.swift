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

enum PomodoroState: Decodable, Encodable {
    case 초기화
    case 할일_진행중
    case 할일_일시정지
    case 할일_완료
    case 휴식_진행중
    case 휴식_일시정지
    case 휴식_완료
}

final class ToDoListData: Object, Comparable {
    @objc dynamic var id: String = Date().toDoListID
    @objc dynamic var isFromYou: Bool = false
    @objc dynamic var messageText: String = ""
    @objc dynamic var date: Date = Date()
    @objc dynamic var isDone: Bool = false
    @objc dynamic var isRepeat: Bool = false
    @objc dynamic var placeName: String = ""
    @objc dynamic var selectedMinute: Int = Config.POMODORO_WORK_TIME_MINUTE
    @objc dynamic var remainingTime: Double = 0
    
    static func < (lhs: ToDoListData, rhs: ToDoListData) -> Bool {
        return lhs.date < rhs.date
    }
    
    
    func setMessageText(messageText: String, isFromYou: Bool = true) {
        self.messageText = messageText
        self.isFromYou = isFromYou
    }
}
