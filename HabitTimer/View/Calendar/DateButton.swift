//
//  DateButton.swift
//  HabitTimer
//
//  Created by najak on 12/1/25.
//

import SwiftUI

struct DateButton: View {
    var value: DateValue
    @ObservedObject var calendarViewModel: CalendarViewModel
    @Binding var selectDate: Date
    
    private var isToday: Bool {
        Calendar.current.isDateInToday(value.date)
    }
    
    private var dayOfWeek: Int {
        Calendar.current.component(.weekday, from: value.date)
    }
    
    private var isSelected: Bool {
        calendarViewModel.isSameDay(date1: value.date, date2: selectDate)
    }
    
    var body: some View {
        VStack {
            Button {
                selectDate = value.date
            } label: {
                VStack(spacing: 3) {
                    Text(isToday ? "오늘" : "")
                        .font(.custom("GmarketSansTTFMedium", size: 12))
                        .foregroundStyle(Color.errorRed)
                        .padding(.bottom, -5)
                    
                    Text("\(value.day)")
                        .font(.custom("GmarketSansTTFBold", size: 18))
                        .fontWeight(.bold)
                        .foregroundColor(calendarViewModel.toDoListExists(on: value.date.yyyyMMddDot) ? (dayOfWeek == 1 ? Color.errorRed : Color.symGray5) : (dayOfWeek == 1 ? Color.sub : Color.symGray4))
                    
                    Circle()
                        .fill(calendarViewModel.toDoListExists(on: value.date.yyyyMMddDot) ?
                              Color.main : Color.white)
                        .frame(width: 6, height: 6)
                }
                .background(
                    Circle()
                        .fill(isSelected ? Color.medium : Color.white)
                        .frame(width: 50, height: 50)
                        .opacity(isSelected ? 1 : 0)
                )
            }
            .disabled(value.date > Date() ? true : false)
        }
    }
}
