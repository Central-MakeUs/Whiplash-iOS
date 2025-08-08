//
//  AlarmRepository.swift
//  Whiplash-iOS
//
//  Created by 남경민 on 8/3/25.
//

import Foundation

public protocol AlarmRepository {
    var addAlarm: @Sendable () async throws -> Alarm { get }
    var getAlarmList: @Sendable () async throws -> [Alarm] { get }
    var alarmOff: @Sendable () async throws -> Void { get }
    var deleteAlarm: @Sendable () async throws -> Void { get }
}
