//
//  UIApplication+Extension.swift
//  HabitTimer
//
//  Created by najak on 11/15/25.
//

import Foundation
import SwiftUI

extension UIApplication {
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
