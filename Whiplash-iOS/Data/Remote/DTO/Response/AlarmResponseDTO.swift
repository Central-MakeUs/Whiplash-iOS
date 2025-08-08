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
    
    func toDomain(id: Int, isToggleOn: Bool) -> Alarm {
        let (ampm, displayTime) = Self.splitAmpmAndTime(from24h: time)
        
        return .init(
            id: id,
            title: alarmPurpose,
            ampm: ampm,
            time: displayTime,
            repeatDays: repeatDays.joined(separator: ", "),
            address: address,
            isToggleOn: isToggleOn
        )
    }
    
    /// 24시간 문자열을 오전/오후 + 12시간 문자열로 변환
    private static func splitAmpmAndTime(from24h time: String) -> (String, String) {
        let comps = time.split(separator: ":")
        let h24 = Int(comps.first ?? "0") ?? 0
        let m = comps.count > 1 ? String(comps[1]) : "00"
        let ampm = h24 < 12 ? "오전" : "오후"
        var h12 = h24 % 12
        if h12 == 0 { h12 = 12 }
        let hh = String(format: "%02d", h12)
        return (ampm, "\(hh):\(m)")
    }
}
