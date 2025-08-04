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
    public init(
        add: @escaping @Sendable () async throws -> Alarm
    ) {
        self.add = add
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
                print(request)
                
                let response: Response<AlarmResponseDTO> = try await apiClient.request(
                    Response<AlarmResponseDTO>.self,
                    target: .addAlarm(request))
                
                if response.isSuccess, let dto = response.result {
                    
                    return dto.toDomain
                    
                } else {
                    throw NSError(domain: "SignIn", code: 0, userInfo: [NSLocalizedDescriptionKey: response.message])
                }
            }
        )
    }()
}
