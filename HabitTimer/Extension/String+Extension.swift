//
//  String+Extension.swift
//  running
//
//  Created by najak on 9/3/25.
//

import Foundation

extension String {
    func toDate() -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.timeZone = TimeZone(identifier: "UTC")
        
        if let date = dateFormatter.date(from: self) {
            return date
        } else {
            return nil
        }
    }
    
    var isNumber: Bool {
        if Int(self) != nil || Double(self) != nil {
            return true
        }
        return false
    }
    
    var newLineRemoved: String {
        return replacingOccurrences(of: "\n", with: " ")
    }
    
    var divisionNewLineFirst: String {
        guard let firstStr =  components(separatedBy: "\n").first else {
            return ""
        }
        return firstStr
    }
    
    var divisionNewLineLast: String {
        guard let lastStr = components(separatedBy: "\n").last else {
            return ""
        }
        return lastStr
    }
}
