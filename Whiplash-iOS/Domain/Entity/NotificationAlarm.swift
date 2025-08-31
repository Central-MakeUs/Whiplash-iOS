//
//  NotificationAlarm.swift
//  Whiplash-iOS
//
//  Created by 남경민 on 8/21/25.
//

import Foundation

struct NotificationAlarm: Equatable, Identifiable, Codable {
    var id: Int
    var title: String
    var hour: Int
    var minute: Int
    var weekdays: Set<Int> // 1=일, 2=월, 3=화, 4=수, 5=목, 6=금, 7=토
    var isEnabled: Bool
    var soundName: String
    
    init(
        id: Int,
        title: String,
        hour: Int,
        minute: Int,
        weekdays: Set<Int>,
        isEnabled: Bool = true,
        soundName: String
    ) {
        self.id = id
        self.title = title
        self.hour = hour
        self.minute = minute
        self.weekdays = weekdays
        self.isEnabled = isEnabled
        self.soundName = soundName
    }
    
    var timeString: String {
        String(format: "%02d:%02d", hour, minute)
    }
    
    var weekdayString: String {
        if weekdays.isEmpty {
            return "한 번만"
        } else if weekdays.count == 7 {
            return "매일"
        } else if weekdays == Set([2,3,4,5,6]) {
            return "주중"
        } else if weekdays == Set([1,7]) {
            return "주말"
        } else {
            let dayNames = ["일", "월", "화", "수", "목", "금", "토"]
            return weekdays.sorted().map { dayNames[$0-1] }.joined(separator: " ")
        }
    }
}
