//
//  RealmManager.swift
//  HabitTimer
//
//  Created by najak on 11/11/25.
//

import RealmSwift
import Foundation

class RealmManager {
    static let shared = RealmManager()
    
    private init() {}
    
    var realm: Realm {
        let container = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.co.kr.oceanbleu")
        let realmURL = container?.appendingPathComponent("habittimer.realm")

#if DELETE_USE
        try! FileManager.default.removeItem(at: realmURL!)
#endif

        let config = Realm.Configuration(fileURL: realmURL, schemaVersion: 1)
        return try! Realm(configuration: config)
    }
}
