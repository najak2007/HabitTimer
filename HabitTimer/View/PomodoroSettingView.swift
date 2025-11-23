//
//  PomodoroSettingView.swift
//  HabitTimer
//
//  Created by najak on 11/23/25.
//

import SwiftUI
import Foundation

struct PomodoroSettingView: View {
    @Binding var focusTime: Int
    @Binding var breakTime: Int
    @Binding var isAutoStart: Bool
    
    var body: some View {
        List {
            Section(header: PomodoroListHeaderView(headerText: "시간 설정", showAlignments: .좌측정렬)) {
                Button(action: {
                    
                }, label: {
                    HStack {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("집중 시간")
                                .font(.custom("GmarketSansTTFMedium", size: 20))
                                .foregroundColor(Color("1F2020"))
                                .multilineTextAlignment(.leading)
                                .padding(.leading, 0)
                            
                            Text("\(focusTime) 분")
                                .font(.custom("GmarketSansTTFMedium", size: 14))
                                .foregroundColor(Color("1F2020").opacity(0.6))
                                .lineSpacing(4)
                                .lineLimit(2)
                                .multilineTextAlignment(.leading)
                        }
                        
                        Spacer()
                        
                        Picker("", selection: $focusTime) {
                            ForEach(1..<61) { minute in
                                Text(String(format: "%02d", minute))
                                    .font(.custom("GmarketSansTTFMedium", size: 14))
                            }
                        }
                        .frame(width: 120)
                        .pickerStyle(.menu)
                        .tint(Color("1F2020"))
                        .onChange(of: focusTime) { oldValue, newValue in
                            if oldValue != newValue {
                                
                            }
                        }
                    }
                })
                
                Button(action: {
                    
                }, label: {
                    HStack {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("휴식 시간")
                                .font(.custom("GmarketSansTTFMedium", size: 20))
                                .foregroundColor(Color("1F2020"))
                                .multilineTextAlignment(.leading)
                                .padding(.leading, 0)
                            
                            Text("\(breakTime) 분")
                                .font(.custom("GmarketSansTTFMedium", size: 14))
                                .foregroundColor(Color("1F2020").opacity(0.6))
                                .lineSpacing(4)
                                .lineLimit(2)
                                .multilineTextAlignment(.leading)
                        }
                        
                        Spacer()
                        
                        Picker("", selection: $breakTime) {
                            ForEach(1..<61) { minute in
                                Text(String(format: "%02d", minute))
                                    .font(.custom("GmarketSansTTFMedium", size: 14))
                            }
                        }
                        .frame(width: 120)
                        .pickerStyle(.menu)
                        .tint(Color("1F2020"))
                        .onChange(of: focusTime) { oldValue, newValue in
                            if oldValue != newValue {
                                
                            }
                        }
                    }
                })
            }
            
            Section(header: PomodoroListHeaderView(headerText: "시작 설정", showAlignments: .좌측정렬)) {
                Button(action: {
                    
                }, label: {
                    HStack {
                        Text("자동으로 휴식 시작")
                            .font(.custom("GmarketSansTTFMedium", size: 20))
                            .foregroundColor(Color("1F2020"))
                            .multilineTextAlignment(.leading)
                            .padding(.leading, 0)
                            
                        Spacer()
                        
                        Toggle(isOn: $isAutoStart) {
                            Label("", systemImage: "flag.fill")
                        }
                    }
                })
            }
        }
        .environment(\.defaultMinListRowHeight, 80)
        .scrollDisabled(true)
    }
}
