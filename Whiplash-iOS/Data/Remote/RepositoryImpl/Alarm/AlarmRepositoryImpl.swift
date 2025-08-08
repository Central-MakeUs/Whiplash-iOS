//
//  AlarmRepositoryImpl.swift
//  Whiplash-iOS
//
//  Created by 남경민 on 8/3/25.
//

import Foundation
import ComposableArchitecture

public struct AlarmRepositoryImpl: AlarmRepository {
    public var addAlarm: @Sendable () async throws -> Alarm
    public var getAlarmList: @Sendable () async throws -> [Alarm]
    public var alarmOff: @Sendable () async throws -> Void
    public var deleteAlarm: @Sendable () async throws -> Void
    public init(
        addAlarm: @escaping @Sendable () async throws -> Alarm,
        getAlarmList: @escaping @Sendable () async throws -> [Alarm],
        alarmOff: @escaping @Sendable () async throws -> Void,
        deleteAlarm: @escaping @Sendable () async throws -> Void
    ) {
        self.addAlarm = addAlarm
        self.getAlarmList = getAlarmList
        self.alarmOff = alarmOff
        self.deleteAlarm = deleteAlarm
    }
}

extension AlarmRepositoryImpl: DependencyKey {
    public static let liveValue: Self = {
        let apiClient = APIClient()
        return Self(
            addAlarm: {

                
                let request = AlarmRequestDTO(address: "서울시 중구 퇴계로 24",
                                              latitude: 37.564213,
                                              longitude: 127.001698,
                                              alarmPurpose: "도서관 정기 출석 알람",
                                              time: "08:30",
                                              repeatDays:  [
                                                "월",
                                                "수",
                                                "금"
                                              ],
                                              soundType: "알람 소리1")
                
                let response: Response<AlarmResponseDTO> = try await apiClient.request(
                    Response<AlarmResponseDTO>.self,
                    target: .addAlarm(request))
                
                if response.isSuccess, let dto = response.result {
                    
                    return dto.toDomain(id: 0, isToggleOn: false)
                    
                } else {
                    throw NSError(domain: "AddAlarm", code: 0, userInfo: [NSLocalizedDescriptionKey: response.message])
                }
            },
            getAlarmList: {
                
                let response: Response<AlarmListResponseDTO> = try await apiClient.request(
                    Response<AlarmListResponseDTO>.self,
                    target: .getAlarmList)
                
                if response.isSuccess, let dto = response.result {
                    
                    return dto.toDomain
                    
                } else {
                    throw NSError(domain: "GetAlarm", code: 0, userInfo: [NSLocalizedDescriptionKey: response.message])
                }
                
            },
            alarmOff: {
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
                    target: .alarmOff(18, request))
                
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
            }
        )
    }()
}
