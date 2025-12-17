//
//  ToDoListViewModel.swift
//  HabitTimer
//
//  Created by najak on 11/11/25.
//

import Foundation
import RealmSwift
import Combine

class ToDoListViewModel: ObservableObject {
    private var realm: Realm?
    
    @Published var toDoList: [ToDoListData] = []
    @Published var toDoListCompletionList: [ToDoListCompletion] = []
    @Published var toDoListSectionCompletionList: [[ToDoListCompletion]] = [[ToDoListCompletion]]()
    
    @Published var selectedIndex: Int = 0
    @Published var selectedToDoListData: ToDoListData = ToDoListData()
    
    var deleteToDoListID: String?
    
    init() {
        realm = RealmManager.shared.realm
        fetchToDoList()
    }
    
    func fetchToDoList(_ date: Date = Date(), _ isOnlyWeekDayShow: Bool = true) {
        guard let realm = realm else { return }
        let results = realm.objects(ToDoListData.self)
        
        if isOnlyWeekDayShow == false {
            toDoList = Array(results).filter { $0.createDate.yyyyMMdd == date.yyyyMMdd  && $0.isDeleteRequest == false}
        } else {
            toDoList = Array(results).filter { $0.setWeekDays & Int(WeekDayValue.getWeekDayForDate(date)) != 0 && $0.isDeleteRequest == false }
        }
    }
    
    func fetchToDoListForWeekDay(_ toDoListData: ToDoListData, _ weekString: String) {
        guard let realm = realm else { return }
        let results = realm.objects(ToDoListData.self)
        
        guard let toDoListItems = Array(results).filter({$0.id == toDoListData.id}).first?.toDoListItems else { return }
        let toDoListCompletionList = Array(toDoListItems).filter({$0.dateForWeek == weekString && $0.isDone == true && $0.selectedMinute > 0})
        var toDoListDateArr: [[ToDoListCompletion]] = [[ToDoListCompletion]]()
        
        var sectionDate: String = ""
        for toDoListCompletion in toDoListCompletionList {
            let dateString = toDoListCompletion.date.yyyyMMdd
            
            if sectionDate.isEmpty || sectionDate != dateString {
                let sectionToDoCompletionArr = toDoListCompletionList.filter({$0.date.yyyyMMdd == dateString})

                if sectionToDoCompletionArr.isEmpty == false {
                    toDoListDateArr.append(sectionToDoCompletionArr)
                }
            }
            sectionDate = dateString
        }
        
        self.toDoListSectionCompletionList = toDoListDateArr
    }
    
    func fetchToDoListForDate(_ toDoListData: ToDoListData, _ date: Date) {
        guard let realm = realm else { return }
        let results = realm.objects(ToDoListData.self)
        
        guard let toDoListItems = Array(results).filter({$0.id == toDoListData.id}).first?.toDoListItems else { return }
        let toDoListCompletionList = Array(toDoListItems).filter({$0.date.yyyyMMdd == date.yyyyMMdd && $0.isDone == true && $0.selectedMinute > 0})
        
        self.toDoListCompletionList = toDoListCompletionList
        
    }
    
    func fetchAllToDoListForWeekDay(_ weekString: String) {
        guard let realm = realm else { return }
        let results = realm.objects(ToDoListData.self)
        let toDoListArray = Array(results)
        var toDoListFinishDoneItemArr: [ToDoListCompletion] = []
        
        
        if toDoListArray.isEmpty == false {
            for toDoListItem in toDoListArray {
                let toDoListArr = toDoListItem.toDoListItems.filter { $0.dateForWeek == weekString && $0.isDone == true && $0.selectedMinute > 0}
                
                if toDoListArr.isEmpty == false {
                    toDoListFinishDoneItemArr.append(contentsOf: toDoListArr)
                }
            }
            
            if toDoListArray.isEmpty == false {
                toDoListCompletionList = toDoListFinishDoneItemArr
            }
        }
    }
    
    func addToDoList(_ toDoListData: ToDoListData, _ isOnlyWeekDayShow: Bool = true) {
        guard let realm = realm else { return }
        do {
            try realm.write {
                realm.add(toDoListData)
                fetchToDoList(toDoListData.createDate, isOnlyWeekDayShow)
            }
        } catch {
            
        }
    }
    
    func deleteToDoList(_ toDoListData: ToDoListData, _ date: Date = Date(), _ isOnlyWeekDayShow: Bool = true, _ isDeleteRequest: Bool = true) {
        guard let realm = realm else { return }
        do {
            try realm.write {
                if isDeleteRequest == false {
                    realm.delete(toDoListData)
                } else {
                    toDoListData.isDeleteRequest = isDeleteRequest
                }
                fetchToDoList(date, isOnlyWeekDayShow)
            }
        } catch {
            
        }
    }
    
    func deleteToDoListUndo(_ date: Date = Date(), _ isOnlyWeekDayShow: Bool = true, _ completionHandle: @escaping((Bool) -> Void)) {
        guard let realm = realm else { return completionHandle(false) }
        
        let toDoListData = realm.objects(ToDoListData.self).filter("isDeleteRequest == true")
        
        do {
            try realm.write {
                var undoCount: Int = 0
                
                for toDoList in toDoListData {
                    toDoList.isDeleteRequest = false
                    undoCount += 1
                }
                
                if undoCount == 0 {
                    completionHandle(false)
                } else {
                    completionHandle(true)
                }
                
                fetchToDoList(date, isOnlyWeekDayShow)
            }
        } catch {
            completionHandle(false)
        }
    }
    
    func updateToDoMessageText(toDoListData: ToDoListData, date: Date, isOnlyWeekDayShow: Bool = true, messageText: String) {
        guard let realm = realm else { return }
        
        do {
            try realm.write {
                toDoListData.messageText = messageText
                fetchToDoList(date, isOnlyWeekDayShow)
            }
        } catch {
            
        }
    }
    
    func updateToWeekDays(toDoListData: ToDoListData, date: Date, isOnlyWeekDayShow: Bool = true, updateWeekDay: Int, isDeleteRequest: Bool = false) {
        guard let realm = realm else { return }
        
        do {
            try realm.write {
                toDoListData.setWeekDays = updateWeekDay
                toDoListData.isDeleteRequest = isDeleteRequest
                fetchToDoList(date, isOnlyWeekDayShow)
            }
        } catch {
            
        }
    }
    
    func deleteToWeekDays(toDoListDataID: String, date: Date, isOnlyWeekDayShow: Bool = true)  {
        guard let realm = realm else { return }
        let results = realm.objects(ToDoListData.self)
        guard let updateToDoData = Array(results).filter({$0.id == toDoListDataID}).first else { return }
        
        let setWeekDays: Int = updateToDoData.setWeekDays ^ WeekDayValue.getWeekDayForDate(date)
        
        updateToWeekDays(toDoListData: updateToDoData, date: date, isOnlyWeekDayShow: isOnlyWeekDayShow, updateWeekDay: setWeekDays)
    }
    
    func deleteToDoListData(toDoListDataID: String, date: Date, isOnlyWeekDayShow: Bool = true)  {
        guard let realm = realm else { return }
        let results = realm.objects(ToDoListData.self)
        guard let deleteToDoData = Array(results).filter({$0.id == toDoListDataID}).first else { return }
        
        deleteToDoList(deleteToDoData, date, isOnlyWeekDayShow, false)
    }
    
    func updateToMinuteTime(toDoListData: ToDoListData, date: Date, isOnlyWeekDayShow: Bool = true, updateMinute: Int, isBreakTime: Bool = false) -> ToDoListData {
        guard let realm = realm else { return toDoListData }
        let results = realm.objects(ToDoListData.self)
        guard let updateToDoData = Array(results).filter({$0.id == toDoListData.id}).first else { return toDoListData }
        
        do {
            try realm.write {
                if isBreakTime == false {
                    updateToDoData.selectedMinute = updateMinute
                } else {
                    updateToDoData.breakMinute = updateMinute
                }
                fetchToDoList(date, isOnlyWeekDayShow)
            }
        } catch {
            return toDoListData
        }
        return updateToDoData
    }
    
    func addCompletionToDoItem(toDoListData: ToDoListData, date: Date, isOnlyWeekDayShow: Bool = true, toDoListCompletion: ToDoListCompletion) {
        guard let realm = realm else { return }
        let results = realm.objects(ToDoListData.self)
        guard let updateToDoData = Array(results).filter({$0.id == toDoListData.id}).first else { return }
        
        do {
            try realm.write {
                updateToDoData.toDoListItems.append(toDoListCompletion)
                fetchToDoList(date, isOnlyWeekDayShow)
            }
        }catch {
        }
    }
    
    func getSelectWeekDayValue(_ weekDayValue: Int, weekDay: String) -> Bool {
        if weekDayValue & WeekDayValue.getWeekDayForString(weekDay) != 0 {
            return true
        }
        return false
    }
    
    func getToDoListForWeekDays(toDoListData: ToDoListData) -> String {
        switch toDoListData.setWeekDays {
        case 62: return WeekDayExpireDate.주중.rawValue
        case 65: return WeekDayExpireDate.주말.rawValue
        case 127: return WeekDayExpireDate.매일.rawValue
        default:
            return getToDoListWeekDayToString(toDoListData: toDoListData)
        }
    }
    
    func getToDoListWeekDayToString(toDoListData: ToDoListData) -> String {
        var weekDayStringArr: [String] = []

        for weekValue in WeekDayValue.allCases {
            if toDoListData.setWeekDays & weekValue.rawValue != 0 {
                weekDayStringArr.append(WeekDayValue.getWeekDayCaseToString(weekValue.rawValue))
            }
        }
        
        return weekDayStringArr.joined(separator: ",")
    }
    
    func subtractSecondsFromDate(seconds: Int, from date: Date) -> Date {
        guard let changeDate = Calendar.current.date(byAdding: .second, value: seconds, to: date) else { return Date() }

        return changeDate
    }
}
