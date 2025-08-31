//
//  AlarmOffResponseDTO.swift
//  Whiplash-iOS
//
//  Created by 남경민 on 8/9/25.
//

import Foundation

public struct AlarmOffResponseDTO: Decodable {
    let offTargetDate: String          // "2025-08-07"
    let offTargetDayOfWeek: String     // "목요일"
    let reactivateDate: String         // "2025-08-10"
    let reactivateDayOfWeek: String    // "일요일"
    let remainingOffCount: Int
}

public struct AlarmOffCountDTO: Decodable {
    let remainingOffCount: Int
}

extension AlarmOffResponseDTO {
    /*
    var toDomain: AlarmOffResult {
        .init(offTargetDate: offTargetDate,
              offTargetDayOfWeek: offTargetDayOfWeek,
              reactivateDate: reactivateDate,
              reactivateDayOfWeek: reactivateDayOfWeek,
              remainingOffCount: remainingOffCount)
    }*/
}
