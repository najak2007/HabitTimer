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
    
    init() {
        realm = RealmManager.shared.realm
        fetchToDoList()
    }
    
    func fetchToDoList(_ date: Date = Date()) {
        guard let realm = realm else { return }
        let results = realm.objects(ToDoListData.self)
        
        if date.yyyyMMdd == Date().yyyyMMdd {
            toDoList = Array(results)
            return
        }
        
        toDoList = Array(results).filter { $0.createDate.yyyyMMdd == date.yyyyMMdd }
        
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
    
    func addToDoList(_ toDoListData: ToDoListData) {
        guard let realm = realm else { return }
        do {
            try realm.write {
                realm.add(toDoListData)
                fetchToDoList()
            }
        } catch {
            
        }
    }
    
    func deleteToDoList(_ toDoListData: ToDoListData) {
        guard let realm = realm else { return }
        do {
            try realm.write {
                realm.delete(toDoListData)
                fetchToDoList()
            }
        } catch {
            
        }
    }
    
    func updateToDoMessageText(toDoListData: ToDoListData, messageText: String) {
        guard let realm = realm else { return }
        
        do {
            try realm.write {
                toDoListData.messageText = messageText
                fetchToDoList()
            }
            
        } catch {
            
        }
    }
    
    func updateToWeekDays(toDoListData: ToDoListData, updateWeekDay: Int) {
        guard let realm = realm else { return }
        
        do {
            try realm.write {
                toDoListData.setWeekDays = updateWeekDay
                fetchToDoList()
            }
        } catch {
            
        }
    }
    
    func addCompletionToDoItem(toDoListData: ToDoListData, toDoListCompletion: ToDoListCompletion) {
        guard let realm = realm else { return }
        let results = realm.objects(ToDoListData.self)
        guard let updateToDoData = Array(results).filter({$0.id == toDoListData.id}).first else { return }
        
        do {
            try realm.write {
                updateToDoData.toDoListItems.append(toDoListCompletion)
                fetchToDoList()
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
        
        print("getToDoListForWeekDays toDoListData.setWeekDays: \(toDoListData.setWeekDays)")
        
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
}
