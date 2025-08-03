//
//  WeekdayPicker.swift
//  Whiplash-iOS
//
//  Created by 남경민 on 8/3/25.
//

import SwiftUI

struct WeekdayPicker: View {
    private let weekdays = ["월", "화", "수", "목", "금", "토", "일"]
    let deviceWidth = UIScreen.main.bounds.width
    @Binding var selectedDays: [Int]
    
    var body: some View {
        let width = (deviceWidth - 60) / 7
        HStack(spacing: 4) {
            ForEach(weekdays.indices, id: \.self) { idx in
                Button(action: {
                    if selectedDays.contains(idx) {
                        selectedDays.removeAll { $0 == idx }
                    } else {
                        selectedDays.append(idx)
                    }
                }) {
 
                    AppText(text: weekdays[idx],
                            style: .body2_m_14,
                            color: selectedDays.contains(idx)
                            ? .lemon400
                            : .gray500)

                }
                .padding(.vertical, 6)
                .padding(.horizontal, 15)
                .frame(width: width, height: 33)
                .background(
                    selectedDays.contains(idx)
                     ?   Color.lemon10
                    : .clear
                )
                .cornerRadius(4)
                .buttonStyle(.plain)
            }
        }
        .frame(maxWidth: .infinity)
        .frame(height: 33)
    }
}

// 미리보기 및 사용 예시
struct WeekdayPicker_Previews: PreviewProvider {
    @State static var selected: [Int] = []
    static var previews: some View {
        WeekdayPicker(selectedDays: $selected)
            .padding()
            .background(.gray900)
    }
}

