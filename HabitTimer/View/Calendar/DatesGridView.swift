//
//  DatesGridView.swift
//  HabitTimer
//
//  Created by najak on 12/1/25.
//

import SwiftUI

struct DatesGridView: View {
    @ObservedObject var calendarViewModel: CalendarViewModel
    
    private let columns = Array(repeating: GridItem(.flexible()), count: Config.WEEKDAY_TITLE.count)
    
    var body: some View {
        // 달력 그리드
        LazyVGrid(columns: columns, spacing: 10) {
            ForEach(calendarViewModel.extractDate(currentMonth: calendarViewModel.currentMonth)) { value in
                if value.day != -1 {
                    DateButton(value: value,
                               calendarViewModel: calendarViewModel,
                               selectDate: $calendarViewModel.selectDate)
                        .onTapGesture {
                            calendarViewModel.checkingDate = value.date
                            calendarViewModel.popupDate = true
                            calendarViewModel.checkingDateFuture()
                        }
                } else {
                    // 날짜 공백때문에 -1이 있을경우 숨긴다
                    Text("\(value.day)").hidden()
                }
            }
        }
    }
}
