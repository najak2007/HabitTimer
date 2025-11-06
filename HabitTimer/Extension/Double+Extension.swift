//
//  Double+Extension.swift
//  running
//
//  Created by najak on 9/10/25.
//

import Foundation

extension Double {
    
    var kilometers: String {
        return String(format: "%.2f", self)
    }
    
    
    var commaValue: String {
        let numberFormatter: NumberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        numberFormatter.groupingSeparator = ","
        return numberFormatter.string(from: NSNumber(value: self)) ?? "0"
    }
    
    var runningPace: String {
        if self.isFinite == false {
            return "_'__\'\'"
        }
        let minPerKm = Int(self * 1000) / 60
        let secPerKm = Int(self * 1000) % 60
        return "\(minPerKm)' \(secPerKm)\'\'"
    }
}
