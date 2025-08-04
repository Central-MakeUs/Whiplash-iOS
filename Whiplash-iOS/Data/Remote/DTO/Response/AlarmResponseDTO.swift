//
//  AlarmResponseDTO.swift
//  Whiplash-iOS
//
//  Created by 남경민 on 8/3/25.
//

import Foundation

public struct AlarmResponseDTO: Respondable {
    let address: String
    let latitude: Double
    let longitude: Double
    let alarmPurpose: String
    let time: String
    let repeatDays: [String]
    let soundType: String
    
}

extension AlarmResponseDTO {
    
    var toDomain: Alarm {
        .init(id: 1,
              title: "",
              ampm: time,
              time: time,
              repeatDays: "",
              address: address,
              isToggleOn: true)
    }
    
}
