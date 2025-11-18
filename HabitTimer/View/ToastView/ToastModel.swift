//
//  ToastModel.swift
//  TodayToDoList
//
//  Created by najak on 7/16/25.
//

import SwiftUI

struct Toast: Equatable {
    var type: ToastStyle
    var title: String
    var message: String
    var duration: Double = 5
}
