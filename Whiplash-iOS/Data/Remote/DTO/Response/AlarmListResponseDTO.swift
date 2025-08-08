//
//  AlarmListResponseDTO.swift
//  Whiplash-iOS
//
//  Created by 남경민 on 8/9/25.
//

import Foundation

struct AlarmListResponseDTO: Codable {
    let isSuccess: Bool
    let code: String
    let message: String
    let result: [AlarmDetailResponseDTO]
}

struct AlarmDetailResponseDTO: Codable {
    let alarmId: Int
    let alarmPurpose: String
    let repeatsDays: [String]
    let time: String
    let address: String
    let latitude: Double
    let longitude: Double
    let isToggleOn: Bool
    let firstUpcomingDay: String
    let firstUpcomingDayOfWeek: String
    let secondUpcomingDay: String
    let secondUpcomingDayOfWeek: String
}

extension AlarmListResponseDTO {
    var toDomain: [Alarm] {
        result.map { dto in
            let components = dto.time.split(separator: ":")
            let hour = Int(components[0]) ?? 0
            let ampm = hour < 12 ? "오전" : "오후"
            
            let formattedTime: String = {
                var h = hour
                if h > 12 { h -= 12 }
                if h == 0 { h = 12 }
                return String(format: "%02d:%@", h, components[1] as CVarArg)
            }()
            
            let repeatDaysString = dto.repeatsDays.joined(separator: ", ")
            
            return Alarm(
                id: dto.alarmId,
                title: dto.alarmPurpose,
                ampm: ampm,
                time: formattedTime,
                repeatDays: repeatDaysString,
                address: dto.address,
                isToggleOn: dto.isToggleOn
            )
        }
    }
}
