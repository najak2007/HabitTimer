//
//  CalendarViewModel.swift
//  HabitTimer
//
//  Created by najak on 12/1/25.
//

import SwiftUI
import Combine
import RealmSwift

var futureDaySelected = PassthroughSubject<Void, Never>()
var expandDaySelected = PassthroughSubject<Bool, Never>()

struct DateValue: Identifiable {
    var id: String = UUID().uuidString
    var day: Int
    var date: Date
    var expandDay: Int = -1
    var isPreviousDay: Bool = true
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
            futureDaySelected.send()
        } else {
            
        }
    }
    
    func extractDate(currentMonth: Int) -> [DateValue] {
        let calendar = Calendar.current
        
        let previousMonth = getCurrentMonth(addingMonth: currentMonth - 1)
        let nextMonth = getCurrentMonth(addingMonth: currentMonth + 1)
        let currentMonth = getCurrentMonth(addingMonth: currentMonth)

        
        var days = currentMonth.getAllDates().compactMap { date -> DateValue in
            let day = calendar.component(.day, from: date)
            return DateValue(day: day, date: date)
        }
        
        let firstWeekday = calendar.component(.weekday, from: days.first?.date ?? Date())
        let lastWeekday = calendar.component(.weekday, from: days.last?.date ?? Date())
        
        if firstWeekday != 0 {
            let previousDays = expandExtractDate(currentMonth: previousMonth, currentWeekday: firstWeekday)
            
            for index in 0 ..< previousDays.count {
                days.insert(DateValue(day: -1, date: previousDays[index].date, expandDay: previousDays[index].day), at: 0)
            }
        }
        
        if lastWeekday != 7 {
            let nextDays = expandExtractDate(currentMonth: nextMonth, currentWeekday: lastWeekday, isPreviousDay: false)
            
            for value in nextDays {
                days.append(DateValue(day: -1, date: value.date, expandDay: value.day, isPreviousDay: false))
            }
        }
        
        return days
    }
    
    func subtractDaysFromDate(days: Int, from date: Date) -> Date {
        guard let changeDate = Calendar.current.date(byAdding: .day, value: -days, to: date) else { return Date() }
        
        return changeDate
    }
    
    func expandExtractDate(currentMonth: Date, currentWeekday: Int, isPreviousDay: Bool = true) -> [DateValue] {
        let calendar = Calendar.current
        let days: [DateValue] = currentMonth.getAllDates().compactMap { date -> DateValue in
            let day = calendar.component(.day, from: date)
            return DateValue(day: day, date: date)
        }
        if isPreviousDay {
            return days.suffix(currentWeekday - 1).reversed()
        }
        
        return Array(days.prefix(7 - currentWeekday))
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
