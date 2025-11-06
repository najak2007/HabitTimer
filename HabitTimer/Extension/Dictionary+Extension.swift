//
//  Dictionary+Extension.swift
//  TodayToDoList
//
//  Created by najak on 7/8/25.
//

import Foundation

extension Dictionary {
    mutating func update(other: Dictionary) {
        for (key, value) in other {
            self.updateValue(value, forKey: key)
        }
    }

    
    /// JSON String으로 변환
    /// - Parameter opt: JSONSerialization Option
    /// - Returns: JSON String
    func toJsonStr(_ opt: JSONSerialization.WritingOptions = []) -> String {
        if let theJSONData = try?  JSONSerialization.data(withJSONObject: self, options: opt),
           let theJSONText = String(data: theJSONData, encoding: String.Encoding.utf8) {
            return theJSONText
        } else {
            return "{}"
        }
    }
    
    func toJsonData(_ opt: JSONSerialization.WritingOptions = []) -> Data {
        guard let theJSONData = try? JSONSerialization.data(withJSONObject: self, options: opt) else { return Data() }
        return theJSONData
    }
}



