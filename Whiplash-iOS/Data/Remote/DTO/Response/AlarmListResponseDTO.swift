//
//  AlarmListResponseDTO.swift
//  Whiplash-iOS
//
//  Created by 남경민 on 8/9/25.
//

import Foundation

struct AlarmItemResponseDTO: Respondable {
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
    let remainingOffCount: Int?
}

extension AlarmItemResponseDTO {
    var toDomain: (Alarm, Place) {
        let components = time.split(separator: ":")
        let hour = Int(components[0]) ?? 0
        let ampm = hour < 12 ? "오전" : "오후"
        
        let formattedTime: String = {
            var h = hour
            if h > 12 { h -= 12 }
            if h == 0 { h = 12 }
            return String(format: "%02d:%@", h, components[1] as CVarArg)
        }()
        
        let repeatDaysString = repeatsDays.joined(separator: ", ")
        
        return (Alarm(
            id: alarmId,
            title: alarmPurpose,
            ampm: ampm,
            time: formattedTime,
            repeatDays: repeatDaysString,
            address: address,
            isToggleOn: isToggleOn,
            soundType: ""
        ), Place(name: alarmPurpose,
                 address: address,
                 latitude: latitude,
                 longitude: longitude))
    }
    
}
