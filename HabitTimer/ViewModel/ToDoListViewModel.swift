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
    
    @Published var selectedIndex: Int = 0
    @Published var selectedToDoListData: ToDoListData = ToDoListData()
    
    init() {
        realm = RealmManager.shared.realm
        fetchToDoList()
    }
    
    func fetchToDoList() {
        guard let realm = realm else { return }
        let results = realm.objects(ToDoListData.self)
        toDoList = Array(results)
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
}
