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
}

extension Alarm {
    static let sampleData: Alarm = .init(
        id: 1,
        title: "눈 떠!",
        ampm: "오전",
        time: "00:00",
        repeatDays: "월,수,금",
        address: "서울시 중랑구",
        isToggleOn: true
    )
    
    static let emptyData: Alarm = .init(
        id: 1,
        title: "",
        ampm: "",
        time: "00:00",
        repeatDays: "",
        address: "",
        isToggleOn: true
    )
    
    static let sampleList: [Alarm] = [
            Alarm(
                id: 1,
                title: "도서관 정기 출석 알람",
                ampm: "오전",
                time: "08:30",
                repeatDays: "수, 금",
                address: "서울시 중구 퇴계로 24",
                isToggleOn: true
            ),
            Alarm(
                id: 2,
                title: "독서실 가는 알람",
                ampm: "오후",
                time: "19:30",
                repeatDays: "목, 토",
                address: "서울시 중구 퇴계로 24",
                isToggleOn: false
            )
        ]
}
