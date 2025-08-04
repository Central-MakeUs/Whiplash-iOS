//
//  AlarmRepository.swift
//  Whiplash-iOS
//
//  Created by 남경민 on 8/3/25.
//

import Foundation

public protocol AlarmRepository {
    var add: @Sendable () async throws -> Alarm { get }
}
