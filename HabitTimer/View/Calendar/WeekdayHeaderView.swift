//
//  WeekdayHeaderView.swift
//  HabitTimer
//
//  Created by najak on 12/1/25.
//

import SwiftUI

struct WeekdayHeaderView: View {
    
    var body: some View {
        HStack {
            ForEach(Config.WEEKDAY_TITLE, id: \.self) { day in
                Text(day)
                    .font(.custom("GmarketSansTTFMedium", size: 18))
                    .frame(maxWidth: .infinity)
                    .foregroundStyle(day == "일" ? .errorRed : Color("1F2020"))
            }
        }
        .padding(.bottom, 5)
    }
}
