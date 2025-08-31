//
//  WeekDay.swift
//  Whiplash-iOS
//
//  Created by 남경민 on 8/11/25.
//

import Foundation

public enum Ampm: String, Equatable, CaseIterable { case am = "오전", pm = "오후" }

public enum Weekday: Int, CaseIterable, Equatable {
    case mon=0, tue, wed, thu, fri, sat, sun
    var label: String {
        switch self {
        case .mon: "월"; case .tue: "화"; case .wed: "수"
        case .thu: "목"; case .fri: "금"; case .sat: "토"; case .sun: "일"
        }
    }
}
