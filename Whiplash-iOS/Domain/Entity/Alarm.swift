//
//  File.swift
//  Whiplash-iOS
//
//  Created by 남경민 on 8/2/25.
//

import Foundation

public struct Alarm: Equatable {
    var id: Int
    var title: String
    var ampm: String
    var time: String
    var repeatDays: String
    var address: String
    var isToggleOn: Bool
    var soundType: String
}

extension Alarm {
    static let sampleData: Alarm = .init(
        id: 1,
        title: "눈 떠!",
        ampm: "오전",
        time: "01:00",
        repeatDays: "월,수,금",
        address: "서울시 중랑구",
        isToggleOn: true,
        soundType: ""
    )
    
    static let emptyData: Alarm = .init(
        id: 1,
        title: "",
        ampm: "",
        time: "01:00",
        repeatDays: "",
        address: "",
        isToggleOn: true,
        soundType: "sound1"
    )
    
    static let sampleList: [Alarm] = [
        Alarm(
            id: 1,
            title: "도서관 정기 출석 알람",
            ampm: "오전",
            time: "08:30",
            repeatDays: "수, 금",
            address: "서울시 중구 퇴계로 24",
            isToggleOn: true,
            soundType: ""
        ),
        Alarm(
            id: 2,
            title: "독서실 가는 알람",
            ampm: "오후",
            time: "19:30",
            repeatDays: "목, 토",
            address: "서울시 중구 퇴계로 24",
            isToggleOn: false,
            soundType: ""
        )
    ]
    
    var toNotificationAlarm: NotificationAlarm {
        .init(id: id,
              title: title,
              hour: extractHour,
              minute: extractMinute,
              weekdays: extractWeekdays,
              soundName: soundType)
    }
    
    // MARK: - 시간 파싱 (time: "01:00" → hour: 1, minute: 0)
    private var extractHour: Int {
        let timeComponents = time.split(separator: ":")
        guard timeComponents.count >= 2,
              let hour = Int(timeComponents[0]) else {
            return 0
        }
        
        // ampm 처리
        if ampm == "오후" && hour != 12 {
            return hour + 12
        } else if ampm == "오전" && hour == 12 {
            return 0
        } else {
            return hour
        }
    }
    
    private var extractMinute: Int {
        let timeComponents = time.split(separator: ":")
        guard timeComponents.count >= 2,
              let minute = Int(timeComponents[1]) else {
            return 0
        }
        return minute
    }
    
    // MARK: - 요일 파싱 (repeatDays: "월,수,금" → Set<Int>)
    private var extractWeekdays: Set<Int> {
        let dayStrings = repeatDays.split(separator: ",").map { $0.trimmingCharacters(in: .whitespaces) }
        var weekdayNumbers: Set<Int> = []
        
        for dayString in dayStrings {
            switch dayString {
            case "일": weekdayNumbers.insert(1)  // Sunday
            case "월": weekdayNumbers.insert(2)  // Monday
            case "화": weekdayNumbers.insert(3)  // Tuesday
            case "수": weekdayNumbers.insert(4)  // Wednesday
            case "목": weekdayNumbers.insert(5)  // Thursday
            case "금": weekdayNumbers.insert(6)  // Friday
            case "토": weekdayNumbers.insert(7)  // Saturday
            default: break
            }
        }
        
        return weekdayNumbers
    }
}

