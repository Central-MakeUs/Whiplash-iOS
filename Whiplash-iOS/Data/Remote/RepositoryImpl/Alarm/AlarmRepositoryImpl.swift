//
//  AlarmRepositoryImpl.swift
//  Whiplash-iOS
//
//  Created by 남경민 on 8/3/25.
//

import Foundation
import ComposableArchitecture

public struct AlarmRepositoryImpl: AlarmRepository {
    public var add: @Sendable () async throws -> Alarm
    public var getAlarmList: @Sendable () async throws -> [Alarm]
    public init(
        add: @escaping @Sendable () async throws -> Alarm,
        getAlarmList: @escaping @Sendable () async throws -> [Alarm]
    ) {
        self.add = add
        self.getAlarmList = getAlarmList
    }
}

extension AlarmRepositoryImpl: DependencyKey {
    public static let liveValue: Self = {
        let apiClient = APIClient()
        return Self(
            add: {

                
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
                
            }
        )
    }()
}
