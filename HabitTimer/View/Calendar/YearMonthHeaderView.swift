//
//  YearMonthHeaderView.swift
//  HabitTimer
//
//  Created by najak on 12/2/25.
//

import SwiftUI

struct YearMonthHeaderView: View {
    @ObservedObject var calendarViewModel: CalendarViewModel
    @Binding var isShowingDateChangeSheet: Bool
    
    var body: some View {
        HStack {
            Text("\(calendarViewModel.getYearAndMonthString(currentDate: calendarViewModel.currentDate)[0])년 \(calendarViewModel.getYearAndMonthString(currentDate: calendarViewModel.currentDate)[1])")
                .font(.custom("GmarketSansTTFBold", size: 20))
            
            Button(action: {
                isShowingDateChangeSheet.toggle()
            }, label: {
                Image(systemName: "chevron.down")
                    .foregroundStyle(Color("1F2020"))
            })
        }
        .sheet(isPresented: $isShowingDateChangeSheet,
               content: { CalendarDatePicker(calendarViewModel: calendarViewModel,
                                     isShowingDateChangeSheet: $isShowingDateChangeSheet)
               .presentationDetents([.fraction(0.4)])
            
        })
    }
}
