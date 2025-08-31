//
//  WeekdayPicker.swift
//  Whiplash-iOS
//
//  Created by 남경민 on 8/3/25.
//

import SwiftUI

struct WeekdayPicker: View {
    let deviceWidth = UIScreen.main.bounds.width
    let selected: Set<Weekday> // @Binding 제거
    let onToggle: (Weekday) -> Void // Action 콜백 추가
    
    private let weekdays = Weekday.allCases
    
    var body: some View {
        let width = (deviceWidth - 60) / 7
        HStack(spacing: 4) {
            ForEach(weekdays, id: \.self) { day in
                let isOn = selected.contains(day)
                Button {
                    onToggle(day) // Action 호출
                } label: {
                    AppText(text: day.label,
                            style: .body2_m_14,
                            color: isOn ? .lemon400 : .gray500)
                }
                .padding(.vertical, 6)
                .padding(.horizontal, 15)
                .frame(width: width, height: 33)
                .background(isOn ? Color.lemon10 : .clear)
                .cornerRadius(4)
                .buttonStyle(.plain)
            }
        }
        .frame(maxWidth: .infinity)
        .frame(height: 33)
    }
}
