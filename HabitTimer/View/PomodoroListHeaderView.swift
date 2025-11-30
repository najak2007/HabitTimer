//
//  PomodoroListHeaderView.swift
//  HabitTimer
//
//  Created by najak on 11/23/25.
//

import SwiftUI

enum HeaderTextAlignment {
    case 좌측정렬
    case 가운데정렬
    case 우측정렬
}

struct PomodoroListHeaderView: View {
    var headerText: String
    var showAlignments: HeaderTextAlignment
    var fontSize: CGFloat = Config.INPUT_VIEW_HEADER_FONT_SIZE
    
    var body: some View {
        HStack {
            if showAlignments == .우측정렬 || showAlignments == .가운데정렬 {
                Spacer()
            }
            
            Text(headerText)
                .font(.custom("GmarketSansTTFLight", size: fontSize))
                .foregroundColor(Color("1F2020"))
            
            if showAlignments == .좌측정렬 || showAlignments == .가운데정렬 {
                Spacer()
            }
        }
    }
}
