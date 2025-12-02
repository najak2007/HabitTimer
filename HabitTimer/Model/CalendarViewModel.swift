//
//  CalendarViewModel.swift
//  HabitTimer
//
//  Created by najak on 12/1/25.
//

import SwiftUI
import Combine
import RealmSwift

struct DateValue: Identifiable {
    var id: String = UUID().uuidString
    var day: Int
    var date: Date
}

final class CalendarViewModel: ObservableObject {
    
    private var realm: Realm?
    
    @Published var currentDate: Date = Date()
    @Published var currentMonth: Int = 0
    @Published var selectDate: Date = Date()
    @Published var selectedYear: Int = Calendar.current.component(.year, from: .now)
    @Published var selectedMonth: Int = Calendar.current.component(.month, from: .now)
    
    @Published var checkingDate: Date = Date()
    @Published var popupDate: Bool = false
    
    @Published var toDoList: [ToDoListData] = []
    
    init() {
        realm = RealmManager.shared.realm
    }

    
    func getCurrentMonth(addingMonth: Int) -> Date {
        let calendar = Calendar.current
        
        guard let currentMonth = calendar.date(
            byAdding: .month,
            value: addingMonth,
            to: Date()
        ) else { return Date() }
        
        return currentMonth
    }
    
    func checkingDateFuture() {
        if popupDate {
            // 미래 날짜는 아직 기록할 수 없어요
        } else {
            
        }
    }
    
    func extractDate(currentMonth: Int) -> [DateValue] {
        let calendar = Calendar.current
        
        let currentMonth = getCurrentMonth(addingMonth: currentMonth)
        
        var days = currentMonth.getAllDates().compactMap { date -> DateValue in
            let day = calendar.component(.day, from: date)
            return DateValue(day: day, date: date)
        }
        
        let firstWeekday = calendar.component(.weekday, from: days.first?.date ?? Date())
        
        for _ in 0 ..< firstWeekday - 1 {
            days.insert(DateValue(day: -1, date: Date()), at: 0)
        }
        
        return days
    }
    
    func isSameDay(date1: Date, date2: Date) -> Bool {
        let calendar = Calendar.current
        return calendar.isDate(date1, inSameDayAs: date2)
    }
    
    func getYearAndMonthString(currentDate: Date) -> [String] {
        let formatter = DateFormatter()
        formatter.dateFormat = "YYYY MMMM"
        formatter.locale = Locale(identifier: "ko_kr")
        
        let date = formatter.string(from: currentDate)
        return date.components(separatedBy: " ")
    }
    
    func toDoListExists(_ toDoListData: ToDoListData, on dateString: String) -> Bool {
        guard let realm = realm else { return false }
        let results = realm.objects(ToDoListData.self)
        
        guard let toDoListItems = Array(results).filter({$0.id == toDoListData.id}).first?.toDoListItems else { return false }
        let toDoListCompletionList = Array(toDoListItems).filter({$0.date.yyyyMMddDot == dateString && $0.isDone == true && $0.selectedMinute > 0})
        
        if !toDoListCompletionList.isEmpty {
            return true
        }
        
        return false
    }
}
