//
//  ToDoDataResultListView.swift
//  HabitTimer
//
//  Created by 오션블루 on 11/27/25.
//

import SwiftUI
import Foundation
import Combine

struct ToDoDataResultListView: View {
    @Environment(\.dismiss) var dismiss
    @State private var weekDayTableIndex: Int = 0
    @State private var isCalendarShow: Bool = false
    @State private var toast: Toast? = nil
    
    @StateObject private var toDoListViewModel = ToDoListViewModel()
    @StateObject private var calendarViewModel: CalendarViewModel = CalendarViewModel()
    
    @Binding var toDoListData: ToDoListData
    
    
    var body: some View {
        NavigationView {
            VStack(spacing: 40) {
                if isCalendarShow == false {
                    Picker("", selection: $weekDayTableIndex) {
                        ForEach(0..<7) { weekDayIndex in
                            Text(Config.WEEKDAY_TITLE[weekDayIndex])
                        }
                    }
                    .pickerStyle(.segmented)
                    .tint(Color("1F2020"))
                    .onChange(of: weekDayTableIndex) { oldValue, newValue in
                        if oldValue != newValue {
                            fetchToDoListForWeekDay(Config.WEEKDAY_TITLE[newValue])
                        }
                    }
                    
                    ScrollViewReader { proxy in
                        List {
                            ForEach(toDoListViewModel.toDoListSectionCompletionList.indices, id: \.self) { sectionIndex in
                                Section(header: PomodoroListHeaderView(headerText: self.getToDoListSectionTitle( toDoListViewModel.toDoListSectionCompletionList[sectionIndex].first), showAlignments: .가운데정렬)) {
                                    ForEach(toDoListViewModel.toDoListSectionCompletionList[sectionIndex].indices, id: \.self) { index in
                                        HStack {
                                            VStack(alignment: .leading, spacing: 5) {
                                                Text("시작 시간")
                                                    .font(.custom("GmarketSansTTFMedium", size: 16))
                                                    .foregroundColor(Color("1F2020")).opacity(0.6)
                                                
                                                Text(toDoListViewModel.toDoListSectionCompletionList[sectionIndex][index].date.HHmm)
                                                    .font(.custom("GmarketSansTTFBold", size: 18))
                                                    .foregroundColor(Color("1F2020"))
                                            }
                                            .padding(.leading, 10)
                                            
                                            Spacer()
                                            
                                            Text("\(String(format: "%02d분", toDoListViewModel.toDoListSectionCompletionList[sectionIndex][index].selectedMinute))")
                                                .font(.custom("GmarketSansTTFMedium", size: 18))
                                                .monospacedDigit()
                                                .background(.clear)
                                                .foregroundColor(Color("1F2020"))
                                                .italic()
                                                .padding(.trailing, 10)
                                        }
                                    }
                                }
                            }
                        }
                        .padding(.top, -34)
                        .overlay {
                            VStack(alignment: .center) {
                                Spacer()
                                
                                Image("icon_list_empty")
                                    .resizable()
                                    .frame(width: 280, height: 187)
                                
                                Spacer()
                            }
                            .opacity(self.toDoListViewModel.toDoListSectionCompletionList.isEmpty ? 1 : 0)
                        }
                    }
                    Spacer()
                } else {
                    VStack {
                        CalendarView(calendarViewModel: calendarViewModel, toDoListData: toDoListData)
                        
                        List {
                            ForEach(toDoListViewModel.toDoListCompletionList.indices, id: \.self) { index in
                                HStack {
                                    VStack(alignment: .leading, spacing: 5) {
                                        Text("시작 시간")
                                            .font(.custom("GmarketSansTTFMedium", size: 16))
                                            .foregroundColor(Color("1F2020")).opacity(0.6)
                                        
                                        Text(toDoListViewModel.toDoListCompletionList[index].date.HHmm)
                                            .font(.custom("GmarketSansTTFBold", size: 18))
                                            .foregroundColor(Color("1F2020"))
                                    }
                                    .padding(.leading, 10)
                                    
                                    Spacer()
                                    
                                    Text("\(String(format: "%02d분", toDoListViewModel.toDoListCompletionList[index].selectedMinute))")
                                        .font(.custom("GmarketSansTTFMedium", size: 18))
                                        .monospacedDigit()
                                        .background(.clear)
                                        .foregroundColor(Color("1F2020"))
                                        .italic()
                                        .padding(.trailing, 10)
                                }
                            }
                        }
                        .padding(.top)
                        .overlay {
                            VStack(alignment: .center) {
                                Spacer()
                                
                                Image("icon_list_empty")
                                    .resizable()
                                    .frame(width: 280, height: 187)
                                
                                Spacer()
                            }
                            .opacity(self.toDoListViewModel.toDoListCompletionList.isEmpty ? 1 : 0)
                        }
                        
                        Spacer()
                    }
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(
                leading: Button(action: {
                    if self.isCalendarShow == false {
                        toDoListViewModel.fetchToDoListForDate(toDoListData, calendarViewModel.selectDate)
                    }
                    self.isCalendarShow.toggle()
                }, label: {
                    if self.isCalendarShow {
                        Image("icon_weekday")
                            .resizable()
                            .frame(width: 40, height: 40)
                            .foregroundColor(Color("1F2020"))
                    } else {
                        Image(systemName: "calendar.badge")
                            .resizable()
                            .frame(width: 30, height: 30)
                            .foregroundColor(Color("1F2020"))
                    }
                }),
                
                trailing: Button(action: {
                    dismiss()
                }, label: {
                    Image(systemName: "xmark.circle.fill")
                        .resizable()
                        .frame(width: 35, height: 35)
                        .foregroundColor(Color("1F2020"))
                })
            )
            .toolbar {
                ToolbarItem(placement: .principal) {
                    VStack(spacing: 5) {
                        Text("완료한 일")
                            .font(.custom("GmarketSansTTFBold", size: Config.MAIN_HEADER_TITLE_FONT_SIZE))
                            .foregroundColor(Color("1F2020"))
                        Text(toDoListData.messageText)
                            .font(.custom("GmarketSansTTFRegular", size: Config.SUB_HEADER_TITLE_FONT_SIZE))
                            .foregroundColor(Color("1F2020"))
                        
                    }
                }
            }
            .toolbarBackground(.hidden, for: .navigationBar)
            .onAppear {
                weekDayTableIndex = Calendar.current.component(.weekday, from: Date()) - 1
                fetchToDoListForWeekDay(Config.WEEKDAY_TITLE[weekDayTableIndex])
            }
            .onReceive(futureDaySelected) {
                toast = Toast(type: .warning, title: "", message: "미래는 확인할 수 없습니다.")
            }
            .onReceive(expandDaySelected) { isPreviousDay in
                if isPreviousDay {
                    calendarViewModel.currentMonth -= 1
                    calendarViewModel.selectedMonth -= 1
                } else {
                    let selectyear = Calendar.current.component(.year, from: calendarViewModel.currentDate)
                    let selectMonth = Calendar.current.component(.month, from: calendarViewModel.currentDate)
                    
                    if selectyear == Config.CALENDAR_START_YEAR && selectMonth == 1 {
                        
                    } else {
                        calendarViewModel.currentMonth += 1
                        calendarViewModel.selectedMonth += 1
                    }
                }
            }
            .onChange(of: calendarViewModel.selectDate) { oldDate, newDate in
                toDoListViewModel.fetchToDoListForDate(toDoListData, newDate)
            }
            .toastView(toast: $toast)
        }
    }
    
    func fetchToDoListForWeekDay(_ weekDayString: String) {
        toDoListViewModel.fetchToDoListForWeekDay(toDoListData, weekDayString)
    }
    
    func getToDoListSectionTitle(_ toDoListCompletion: ToDoListCompletion?) -> String {
        guard let toDoListCompletion else { return "" }
        return toDoListCompletion.date.yyyyMMddDot
    }
}
