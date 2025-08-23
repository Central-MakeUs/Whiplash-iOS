//
//  NotificationClient.swift
//  Whiplash-iOS
//
//  Created by 남경민 on 8/21/25.
//

import ComposableArchitecture
import UserNotifications
import Foundation

struct NotificationClient {
    var requestPermission: @Sendable () async -> Bool
    var scheduleNotification: @Sendable (NotificationAlarm) async throws -> Void
    var cancelNotification: @Sendable (NotificationAlarm) async -> Void
    var getPendingNotifications: @Sendable () async -> [UNNotificationRequest]
    var scheduleRepeatingAlarm: @Sendable (NotificationAlarm, TimeInterval, Double) async throws -> Void
    var cancelRepeatingAlarm: @Sendable (_ alarmId: Int) async throws -> Void
    var scheduleBurstFromNow: @Sendable (_ alarm: NotificationAlarm, _ intervalSeconds: Int, _ count: Int) async throws -> Void
    
}

extension NotificationClient: DependencyKey {
    static let liveValue = NotificationClient(
        requestPermission: {
            await withCheckedContinuation { continuation in
                UNUserNotificationCenter.current().requestAuthorization(
                    options: [.alert, .sound, .badge]
                ) { granted, _ in
                    continuation.resume(returning: granted)
                }
            }
        },
        
        scheduleNotification: { alarm in
            // 타입 변환 (여기서는 EmbeddedSoundAlarm을 사용한다고 가정)
            guard let alarm = alarm as? NotificationAlarm else {
                throw NotificationError.invalidAlarmType
            }
            
            await cancelNotificationForAlarm(alarm)
            
            let content = UNMutableNotificationContent()
            content.title = "눈 떠"
            content.body = "알람이 울리고 있어요!\n앱으로 접속해서 알람을 꺼주세요!"
            content.badge = 1
            content.categoryIdentifier = "ALARM"
            content.userInfo = [
                "alarmId": alarm.id,
                "soundId": alarm.soundName
            ]
            
            content.sound = createNotificationSound(for: alarm.soundName)
            
            if alarm.weekdays.isEmpty {
                try await scheduleOneTimeNotification(alarm: alarm, content: content)
            } else {
                try await scheduleRepeatNotification(alarm: alarm, content: content)
            }
        },
        
        cancelNotification: { alarm in
            guard let alarm = alarm as? NotificationAlarm else { return }
            await cancelNotificationForAlarm(alarm)
        },
        
        getPendingNotifications: {
            await withCheckedContinuation { continuation in
                UNUserNotificationCenter.current().getPendingNotificationRequests { requests in
                    continuation.resume(returning: requests)
                }
            }
        },
        // 🔥 집중 알림 스케줄링 (1초마다!)
        scheduleRepeatingAlarm: { alarm, intervalSeconds, maxCount in
            guard let alarm = alarm as? NotificationAlarm else {
                throw NotificationError.invalidAlarmType
            }
            
            await cancelRepeatingAlarmNotifications(alarmId: alarm.id)
            
            let calendar = Calendar.current
            let now = Date()
            
            var todayComponents = calendar.dateComponents([.year, .month, .day], from: now)
            todayComponents.hour = alarm.hour
            todayComponents.minute = alarm.minute
            todayComponents.second = 0
            
            guard let todayAlarmTime = calendar.date(from: todayComponents) else {
                throw NotificationError.dateCalculationFailed
            }
            
            let startTime = todayAlarmTime > now ? todayAlarmTime : calendar.date(byAdding: .day, value: 1, to: todayAlarmTime)!
            
            let actualMaxCount = min(maxCount, 64)
            
            for i in stride(from: 0, through: actualMaxCount, by: intervalSeconds) {
                let content = UNMutableNotificationContent()
                
                content.title = "눈 떠"
                content.body = "알람이 울리고 있어요!\n앱으로 접속해서 알람을 꺼주세요!"
                content.badge = NSNumber(value: i + 1)
                content.categoryIdentifier = "ALARM"
                
                
                content.sound = createNotificationSound(for: alarm.soundName)
                
                
                content.userInfo = [
                    "alarmId": alarm.id,
                    "soundId": alarm.soundName,
                    "sequence": i,
                    "isIntensive": true
                ]
                
                let triggerDate = startTime.addingTimeInterval(TimeInterval(i))
                let triggerComponents = calendar.dateComponents(
                    [.year, .month, .day, .hour, .minute, .second],
                    from: triggerDate
                )
                
                let trigger = UNCalendarNotificationTrigger(dateMatching: triggerComponents, repeats: false)
                let identifier = "repeating_alarm_\(alarm.id)_\(i)"
                let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
                
                try await UNUserNotificationCenter.current().add(request)
            }
            
            // 🔥 64초 후 더 긴 간격으로 계속 알림 (1분마다)
            if maxCount > 64 {
                try await scheduleExtendedAlarm(alarm: alarm, startTime: startTime.addingTimeInterval(64))
            }
        },
        cancelRepeatingAlarm: { alarmId in
            try await cancelRepeatingAlarmNotifications(alarmId: alarmId)
        },
        scheduleBurstFromNow: { alarm, intervalSeconds, count in
            await cancelRepeatingAlarmNotifications(alarmId: alarm.id)
            let center = UNUserNotificationCenter.current()
            let safeCount = max(1, min(count, 64))             // 시스템 대기 등록 한도
            let safeInterval = max(1, intervalSeconds)         
            
            for i in 0..<safeCount {
                let content = UNMutableNotificationContent()
                content.title = "눈 떠"
                content.body = "알람이 울리고 있어요!\n앱으로 접속해서 알람을 꺼주세요!"
                content.badge = NSNumber(value: i + 1)
                content.categoryIdentifier = "ALARM"
                content.userInfo = [
                    "alarmId": alarm.id,
                    "soundId": alarm.soundName,
                    "seq": i,
                    "fromNow": true
                ]
                
                content.sound = createNotificationSound(for: alarm.soundName)
                
                if #available(iOS 15.0, *) {
                    content.interruptionLevel = .timeSensitive
                }
                
                if i == 0 {
                    // 첫 알림은 "거의 즉시" → 1~2초 뒤
                    let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 2, repeats: false)
                    try await center.add(UNNotificationRequest(
                        identifier: "repeating_alarm_\(alarm.id)_\(i)", content: content, trigger: trigger)
                    )
                } else {
                    // 이후는 now 기준 상대 간격
                    let trigger = UNTimeIntervalNotificationTrigger(
                        timeInterval: TimeInterval(safeInterval * i),
                        repeats: false
                    )
                    try await center.add(UNNotificationRequest(
                        identifier: "repeating_alarm_\(alarm.id)_\(i)", content: content, trigger: trigger)
                    )
                }
            }
        }
    )
}

// MARK: - 내장 사운드 알림 헬퍼 함수들
private func createNotificationSound(for alarm: String) -> UNNotificationSound {
    let selectedSound = alarm
    
    // 파일 존재 확인
    guard Bundle.main.url(forResource: selectedSound, withExtension: "mp3") != nil else {
        print("사운드 파일 누락: \(selectedSound), 기본 사운드 사용")
        return .default
    }
    
    // UNNotificationSound 생성
    return UNNotificationSound(named: UNNotificationSoundName(selectedSound+".mp3"))
}

@Sendable
private func scheduleOneTimeNotification(alarm: NotificationAlarm, content: UNMutableNotificationContent) async throws {
    let calendar = Calendar.current
    let now = Date()
    
    var todayComponents = calendar.dateComponents([.year, .month, .day], from: now)
    todayComponents.hour = alarm.hour
    todayComponents.minute = alarm.minute
    todayComponents.second = 0
    
    guard let todayAlarmTime = calendar.date(from: todayComponents) else {
        throw NotificationError.dateCalculationFailed
    }
    
    let targetDate = todayAlarmTime > now ? todayAlarmTime : calendar.date(byAdding: .day, value: 1, to: todayAlarmTime)!
    let triggerComponents = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: targetDate)
    
    let trigger = UNCalendarNotificationTrigger(dateMatching: triggerComponents, repeats: false)
    let request = UNNotificationRequest(identifier: String(alarm.id), content: content, trigger: trigger)
    
    try await UNUserNotificationCenter.current().add(request)
}

@Sendable
private func scheduleRepeatNotification(alarm: NotificationAlarm, content: UNMutableNotificationContent) async throws {
    for weekday in alarm.weekdays {
        var components = DateComponents()
        components.hour = alarm.hour
        components.minute = alarm.minute
        components.second = 0
        components.weekday = weekday
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: true)
        let identifier = "repeating_alarm_\(alarm.id)"
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
        
        try await UNUserNotificationCenter.current().add(request)
    }
}

@Sendable
private func cancelNotificationForAlarm(_ alarm: NotificationAlarm) async {
    UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [String(alarm.id)])
    
    let weekdayIdentifiers = (1...7).map { "repeating_alarm_\(alarm.id)_\($0)" }
    UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: weekdayIdentifiers)
}

@Sendable
private func cancelRepeatingAlarmNotifications(alarmId: Int) async {
    let center = UNUserNotificationCenter.current()
    let pendingRequests = await withCheckedContinuation { continuation in
        center.getPendingNotificationRequests { requests in
            continuation.resume(returning: requests)
        }
    }
    
    let repeatingIdentifiers = pendingRequests
        .filter { $0.identifier.hasPrefix("repeating_alarm_\(alarmId)_") }
        .map { $0.identifier }
    
    center.removePendingNotificationRequests(withIdentifiers: repeatingIdentifiers)
}

@Sendable
private func scheduleExtendedAlarm(alarm: NotificationAlarm, startTime: Date) async throws {
    for i in 0..<30 { // 30분 더
        let content = UNMutableNotificationContent()
        content.title = "눈 떠"
        content.body = "알람이 울리고 있어요!\n앱으로 접속해서 알람을 꺼주세요!"
        content.badge = NSNumber(value: i + 65)
        content.categoryIdentifier = "ALARM"
        content.sound = UNNotificationSound(named: UNNotificationSoundName("\(alarm.soundName).mp3"))
        
        content.userInfo = [
            "alarmId": alarm.id,
            "soundId": alarm.soundName,
            "sequence": i + 64,
            "isExtended": true
        ]
        
        let calendar = Calendar.current
        let triggerDate = startTime.addingTimeInterval(TimeInterval(i * 60)) // 1분마다
        let triggerComponents = calendar.dateComponents([.year, .month, .day, .hour, .minute, .second], from: triggerDate)
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: triggerComponents, repeats: false)
        let identifier = "repeating_alarm_\(alarm.id)_\(i)"
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
        
        try await UNUserNotificationCenter.current().add(request)
    }
}

enum NotificationError: Error {
    case dateCalculationFailed
    case permissionDenied
    case invalidAlarmType
}
