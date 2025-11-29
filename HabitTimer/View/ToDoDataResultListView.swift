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
    
    @StateObject private var toDoListViewModel = ToDoListViewModel()
    @Binding var toDoListData: ToDoListData
    
    
    var body: some View {
        NavigationView {
            VStack(spacing: 40) {
                Picker("", selection: $weekDayTableIndex) {
                    ForEach(0..<7) { weekDayIndex in
                        Text(Config.WEEKDAY_TITLE[weekDayIndex])
                    }
                }
                .pickerStyle(.segmented)
                .tint(Color("1F2020"))

                ScrollViewReader { proxy in
                    List {
                        ForEach(toDoListViewModel.toDoListCompletionList.indices, id: \.self) { index in
                            HStack {
                                VStack(alignment: .leading, spacing: 5) {
                                    Text("시작 시간")
                                        .font(.custom("GmarketSansTTFMedium", size: 16))
                                        .foregroundColor(Color("1F2020")).opacity(0.6)
                                              
                                    Text(toDoListViewModel.toDoListCompletionList[index].date.yyyyMMddDot)
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
                }
                
                
                Spacer()
            }
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(
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
                    HStack {
                        Text("완료한 일")
                            .font(.custom("GmarketSansTTFBold", size: Config.MAIN_HEADER_TITLE_FONT_SIZE))
                            .foregroundColor(Color("1F2020"))
                        
                    }
                }
            }
            .toolbarBackground(.hidden, for: .navigationBar)
            .onAppear {
                weekDayTableIndex = Calendar.current.component(.weekday, from: Date()) - 1
                
                toDoListViewModel.fetchToDoListForWeekDay(toDoListData, Config.WEEKDAY_TITLE[weekDayTableIndex])
            }
        }
    }
}
