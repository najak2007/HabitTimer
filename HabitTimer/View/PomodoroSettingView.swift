//
//  PomodoroSettingView.swift
//  HabitTimer
//
//  Created by najak on 11/23/25.
//

import SwiftUI
import Foundation
import Combine

struct PomodoroSettingView: View {
    var focusTime: Int
    var breakTime: Int
    @State private var focusTimeIndex: Int = 0
    @State private var breakTimeIndex: Int = 0
    
    @Binding var isAlarmStatus: Bool
    @Binding var isFullScreen: Bool
    
    @State private var toast: Toast? = nil
    
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
                        
                        Picker("", selection: $focusTimeIndex) {
                            ForEach(0..<60) { minute in
                                Text(String(format: "%02d분", (minute + 1)))
                                    .font(.custom("GmarketSansTTFMedium", size: 14))
                            }
                        }
                        .frame(width: 120)
                        .pickerStyle(.menu)
                        .tint(Color("1F2020"))
                        .onChange(of: focusTimeIndex) { oldValue, newValue in
                            if oldValue != 0, oldValue != newValue {
                                focusTimeSetting.send(newValue + 1)
                            }
                        }
                    }
                })
                .onAppear {
                    if focusTime > 0 {
                        focusTimeIndex = focusTime - 1
                    }
                    self.isAlarmStatus = UserDefaults.standard.bool(forKey: Config.NOTIFICATION_SETTING_ID)
                }
                
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
                        
                        Picker("", selection: $breakTimeIndex) {
                            ForEach(0..<60) { minute in
                                Text(String(format: "%02d분", (minute + 1)))
                                    .font(.custom("GmarketSansTTFMedium", size: 14))
                            }
                        }
                        .frame(width: 120)
                        .pickerStyle(.menu)
                        .tint(Color("1F2020"))
                        .onChange(of: breakTimeIndex) { oldValue, newValue in
                            if oldValue != 0, oldValue != newValue {
                                breakTimeSetting.send(newValue + 1)
                            }
                        }
                    }
                })
                .onAppear {
                    if breakTime > 0 {
                        breakTimeIndex = breakTime - 1
                    }
                }
            }
            
            Section(header: PomodoroListHeaderView(headerText: "뽀모도로 설정", showAlignments: .좌측정렬)) {
                ScrollView(.horizontal, showsIndicators: false) {
                    LazyHStack(spacing: 3) {
                        ForEach(Config.WEEKDAY_TITLE.indices, id: \.self) { index in
                            Text(Config.WEEKDAY_TITLE[index])
                                .font(.custom("GmarketSansTTFMedium", size: 16))
                                .foregroundStyle(Color("1F2020"))
                                .padding()
                                .background(.clear)
                                .cornerRadius(16)
                        }
                    }
                    .padding(.horizontal, 5)
                }
                .scrollDisabled(true)
                
                
                Button(action: {
                    
                }, label: {
                    HStack {
                        Text("알림 설정")
                            .font(.custom("GmarketSansTTFMedium", size: 20))
                            .foregroundColor(Color("1F2020"))
                            .multilineTextAlignment(.leading)
                            .padding(.leading, 0)
                            
                        Spacer()
                        
                        Toggle(isOn: $isAlarmStatus) {
                            Label("", systemImage: "flag.fill")
                        }
                        .labelsHidden()
                        .onChange(of: isAlarmStatus) { oldValue, newValue in
                            if oldValue == false, newValue == true {
                                NotificationManager.instance.getNotificationSettings { authStatus in
                                    if authStatus.authorizationStatus != .authorized {
                                        self.isAlarmStatus = false
                                        DispatchQueue.main.async {
                                            toast = Toast(type: .info, title: "", message: "알림 권한 허용 필요 (설정 > 알림 허용)", position: .center)
                                        }
                                    }
                                }
                            }
                        }
                    }
                })
                
                Button(action: {
                    
                }, label: {
                    HStack {
                        Text("전체 화면")
                            .font(.custom("GmarketSansTTFMedium", size: 20))
                            .foregroundColor(Color("1F2020"))
                            .multilineTextAlignment(.leading)
                            .padding(.leading, 0)
                            
                        Spacer()
                        
                        Toggle(isOn: $isFullScreen) {
                            Label("", systemImage: "flag.fill")
                        }
                        .labelsHidden()
                    }
                })
            }
        }
        .toastView(toast: $toast)
        .environment(\.defaultMinListRowHeight, 80)
        .scrollDisabled(true)
    }
}
