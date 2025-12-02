//
//  CalendarView.swift
//  HabitTimer
//
//  Created by najak on 12/2/25.
//

import SwiftUI


struct CalendarView: View {
    @State private var offset: CGSize = CGSize()
    @StateObject private var calendarViewModel: CalendarViewModel = CalendarViewModel()
    @State private var isShowingDateChangeSheet: Bool = false
    var toDoListData: ToDoListData
    
    var body: some View {
        VStack {
            VStack(spacing: 20) {
                YearMonthHeaderView(calendarViewModel: calendarViewModel,isShowingDateChangeSheet: $isShowingDateChangeSheet)
                WeekdayHeaderView()
            }
            DatesGridView(calendarViewModel: calendarViewModel, toDoListData: toDoListData)
        }
        .padding(.top, 15)
        .onChange(of: calendarViewModel.currentMonth) { oldMonth, newMonth in
            calendarViewModel.currentDate = calendarViewModel.getCurrentMonth(addingMonth: calendarViewModel.currentMonth)
        }
        .gesture(
            DragGesture()
                .onChanged { gesture in
                    self.offset = gesture.translation
                }
                .onEnded { gesture in
                    let calender = Calendar.current
                    let selectyear = calender.component(.year, from: calendarViewModel.currentDate)
                    let selectMonth = calender.component(.month, from: calendarViewModel.currentDate)
                    let presentMonth = calender.component(.month, from: Date())
                    
                    if gesture.translation.width < -20 {
                        if selectMonth == presentMonth {
                            
                        } else {
                            calendarViewModel.currentMonth += 1
                            calendarViewModel.selectedMonth += 1
                        }
                    } else if gesture.translation.width > 20 {
                        if selectyear == 2026 && selectMonth == 1 {
                            
                        } else {
                            calendarViewModel.currentMonth -= 1
                            calendarViewModel.selectedMonth -= 1
                        }
                    }
                    self.offset = CGSize()
                }
        )
    }
}
