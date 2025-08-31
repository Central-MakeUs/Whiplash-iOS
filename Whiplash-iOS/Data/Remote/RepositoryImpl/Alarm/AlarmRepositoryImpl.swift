//
//  AlarmRepositoryImpl.swift
//  Whiplash-iOS
//
//  Created by 남경민 on 8/3/25.
//

import Foundation
import ComposableArchitecture

public struct AlarmRepositoryImpl: AlarmRepository {
    public var addAlarm: @Sendable (_ alarm: Alarm, _ place: Place) async throws -> Int
    public var getAlarmList: @Sendable () async throws -> ([Alarm], [Place])
    public var alarmOff: @Sendable (_ alarmId: Int) async throws -> Void
    public var deleteAlarm: @Sendable () async throws -> Void
    public var checkInAlarm: @Sendable (_ alarmId: Int, _ place: Place) async throws -> Void
    public var offCount: @Sendable () async throws -> Int
    public init(
        addAlarm: @escaping @Sendable (_ alarm: Alarm, _ place: Place) async throws -> Int,
        getAlarmList: @escaping @Sendable () async throws -> ([Alarm], [Place]),
        alarmOff: @escaping @Sendable (_ alarmId: Int) async throws -> Void,
        deleteAlarm: @escaping @Sendable () async throws -> Void,
        checkInAlarm: @escaping @Sendable (_ alarmId: Int, _ place: Place) async throws -> Void,
        offCount: @escaping @Sendable () async throws -> Int
    ) {
        self.addAlarm = addAlarm
        self.getAlarmList = getAlarmList
        self.alarmOff = alarmOff
        self.deleteAlarm = deleteAlarm
        self.checkInAlarm = checkInAlarm
        self.offCount = offCount
    }
}

extension AlarmRepositoryImpl: DependencyKey {
    public static let liveValue: Self = {
        let apiClient = APIClient()
        return Self(
            addAlarm: { alarm, place in
                let time = TimeConverter.convert12To24(time: alarm.time, ampm: alarm.ampm)!
                let request = AlarmRequestDTO(address: place.address,
                                              latitude: place.latitude,
                                              longitude: place.longitude,
                                              alarmPurpose: alarm.title,
                                              time: time,
                                              repeatDays: StringArrayConverter.stringToArray(alarm.repeatDays),
                                              soundType: alarm.soundType)
                
                let response: Response<AlarmDTO> = try await apiClient.request(
                    Response<AlarmDTO>.self,
                    target: .addAlarm(request))
                
                if response.isSuccess {
                    return response.result?.alarmId ?? 0
                } else {
                    throw NSError(domain: "AddAlarm", code: 0, userInfo: [NSLocalizedDescriptionKey: response.message])
                }
                
            },
            getAlarmList: {
                
                let response: Response<[AlarmItemResponseDTO]> = try await apiClient.request(
                    Response<[AlarmItemResponseDTO]>.self,
                    target: .getAlarmList)
                
                if response.isSuccess, let dto = response.result {
                    
                    let alarm = dto.map { $0.toDomain.0 }
                    let place = dto.map { $0.toDomain.1 }
                    
                    return (alarm, place)
                    
                } else {
                    throw NSError(domain: "GetAlarm", code: 0, userInfo: [NSLocalizedDescriptionKey: response.message])
                }
                
            },
            alarmOff: { alarmId in
                let time: DateFormatter = {
                    let f = DateFormatter()
                    f.calendar = Calendar(identifier: .iso8601)
                    f.locale = Locale(identifier: "ko_KR_POSIX")
                    f.timeZone = TimeZone(identifier: "Asia/Seoul")
                    f.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS"
                    return f
                }()
                
                let request = AlarmOffRequestDTO(clientNow: time.string(from: Date()))

                let response: Response<AlarmOffResponseDTO> = try await apiClient.request(
                    Response<AlarmOffResponseDTO>.self,
                    target: .alarmOff(alarmId, request))
                
                if response.isSuccess, let dto = response.result {
                    
                } else {
                    throw NSError(domain: "AlarmOff", code: 0, userInfo: [NSLocalizedDescriptionKey: response.message])
                }
            },
            deleteAlarm: {
                let request = ReasonDTO(reason: "너무 자주 울려용")
                
                let response: Response<EmptyDTO> = try await apiClient.request(
                    Response<EmptyDTO>.self,
                    target: .deleteAlarm(18, request))
                
                if response.isSuccess, let dto = response.result {
                    
                } else {
                    throw NSError(domain: "DeleteAlarm", code: 0, userInfo: [NSLocalizedDescriptionKey: response.message])
                }
            },
            checkInAlarm: { alarmId, place in
                let request = AlarmCheckInRequestDTO(latitude: place.latitude,
                                                     longitude: place.longitude)
                
                let response: Response<EmptyDTO> = try await apiClient.request(
                    Response<EmptyDTO>.self,
                    target: .checkInAlarm(alarmId, request))
                
                if response.isSuccess, let dto = response.result {
                    
                } else {
                    throw NSError(domain: "CheckInAlarm", code: 0, userInfo: [NSLocalizedDescriptionKey: response.message])
                }
            },
            offCount: {

                
                let response: Response<AlarmOffCountDTO> = try await apiClient.request(
                    Response<AlarmOffCountDTO>.self,
                    target: .offCount)
                
                if response.isSuccess, let dto = response.result {
                    return dto.remainingOffCount
                } else {
                    throw NSError(domain: "CheckInAlarm", code: 0, userInfo: [NSLocalizedDescriptionKey: response.message])
                }
            }
        )
    }()
}
