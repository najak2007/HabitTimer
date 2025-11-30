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
    @Published var toDoListSectionCompletionList: [[ToDoListCompletion]] = [[]]
    
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
        var toDoListSectionCompletionList: [[ToDoListCompletion]] = [[]]
        
        var sectionIndex: Int = 0
        var sectionDate: String = ""
        
        for toDoListCompletion in toDoListCompletionList {
            let dateString = toDoListCompletion.date.yyyyMMdd
            
            if sectionDate.isEmpty || sectionDate == dateString {
                toDoListSectionCompletionList[sectionIndex].append(toDoListCompletion)
            } else {
                sectionIndex += 1
                toDoListSectionCompletionList[sectionIndex].append(toDoListCompletion)
            }
            sectionDate = dateString
        }
        
        self.toDoListSectionCompletionList = toDoListSectionCompletionList
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
}
