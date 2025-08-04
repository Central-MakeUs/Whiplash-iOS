//
//  File.swift
//  Whiplash-iOS
//
//  Created by 남경민 on 8/2/25.
//

import Foundation

public struct Alarm {
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
}
