//
//  PomodoroModel.swift
//  HabitTimer
//
//  Created by najak on 11/7/25.
//

import Foundation
import Combine

var minutePassed = PassthroughSubject<Bool, Never>()

enum PomodoroState: Decodable, Encodable {
    case 초기화
    case 할일_진행중
    case 할일_일시정지
    case 할일_완료
    case 휴식_진행중
    case 휴식_일시정지
    case 휴식_완료
}
