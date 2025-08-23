//
//  AlarmSound.swift
//  Whiplash-iOS
//
//  Created by 남경민 on 8/22/25.
//

import Foundation

public struct AlarmSound: Equatable, Codable, Identifiable {
    public let id: String
    let displayName: String
    let fileName: String
    let duration: TimeInterval
    
    enum SoundCategory: String, CaseIterable, Codable {
        case sound1 = "sound1"
        case sound2 = "sound2"
        case sound3 = "sound3"
        case sound4 = "sound4"
        case none = "nonesound"
    }
}

// MARK: - 앱에 내장된 알람 사운드들
extension AlarmSound {
    static let sounds: [AlarmSound] = [
        // 클래식 알람
        AlarmSound(
            id: "sound1",
            displayName: "카리나의 쓴소리",
            fileName: "sound1.mp3",
            duration: 21.0
        ),
        AlarmSound(
            id: "sound2",
            displayName: "일어나 움직여",
            fileName: "sound2.mp3",
            duration: 30.0
        ),
        AlarmSound(
            id: "sound3",
            displayName: "경고! 내 인생!",
            fileName: "sound3.mp3",
            duration: 26.0
        ),
        
        AlarmSound(
            id: "sound4",
            displayName: "나는 조선의 자존심",
            fileName: "sound4.mp3",
            duration: 30.0
        ),
        AlarmSound(
            id: "nonesound",
            displayName: "소리 없음",
            fileName: "nonesound.mp3",
            duration: 1.0
        ),
    ]
    static let sample: AlarmSound = .init(
        id: "sound1",
        displayName: "카리나의 쓴소리",
        fileName: "sound1.mp3",
        duration: 21.0
    )
    
    static let allSounds: [AlarmSound] = sounds
    
}
