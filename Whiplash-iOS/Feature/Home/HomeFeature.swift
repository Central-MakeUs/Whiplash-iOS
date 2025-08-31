//
//  HomeFeature.swift
//  Whiplash-iOS
//
//  Created by 남경민 on 8/2/25.
//

import Foundation
import ComposableArchitecture

@Reducer
public struct HomeFeature {
    public init() {}
    
    @ObservableState
    public struct State: Equatable {
        public init() {}
        var card: IdentifiedArrayOf<AlarmCardFeature.State> = []
    }
    
    public enum Action {
        case onAppear
        case didFinishGetList(Result<([Alarm], [Place]), Error>)
        case card(IdentifiedActionOf<AlarmCardFeature>)
        case addButtonTapped
        case settingButtonTapped
        case delegate(Delegate)
        
        public enum Delegate: Equatable {
            case addAlarmTapped
            case moveToSetting
            case verifyAlarm(MapStyle)
        }
    }
    
    @Dependency(\.alarmRepository) var alarmRepository
    @Dependency(\.notificationClient) var notificationClient
    
    public var body: some ReducerOf<Self> {
        Reduce { state, action in
            Logger.shared.log(category: .ui, "[HomeFeature] 🟡 액션 수신: \(action)")
                        
            
            switch action {
                
            case .onAppear:
                Logger.shared.log(category: .ui, "HomeFeature.onAppear 호출됨")
                
                return .run { send in
                    Logger.shared.log(category: .network, "알람 리스트 요청 시작")
                    let result = await Result {
                        try await alarmRepository.getAlarmList()
                    }
                    try await notificationClient.requestPermission()
                    Logger.shared.log(category: .network, "알람 리스트 요청 완료 → \(result)")
                    await send(.didFinishGetList(result))
                }
                // 가장 중요한 부분 - 모든 경우를 명시적으로 처리
            case let .card(.element(id: _, action: .delegate(.verifyAlarm(mapStyle)))):
                Logger.shared.log(category: .ui, "🟡 HomeFeature.card 액션 수신")
                
                return .send(.delegate(.verifyAlarm(mapStyle)))
                
            case let .didFinishGetList(.success((alarmList, placeList))):
                Logger.shared.log(category: .database, "알람 리스트 수신 성공 → \(alarmList.count)개")
                state.card = IdentifiedArray(uniqueElements:
                                                zip(alarmList, placeList).map { alarm, place in
                    AlarmCardFeature.State(alarm: alarm, place: place)
                }
                )
                return .none
                
            case let .didFinishGetList(.failure(error)):
                Logger.shared.log(level: .error, category: .network, "알람 리스트 요청 실패 → \(error.localizedDescription)")
                return .none
                
            case .card:
                return .none
                
            case .addButtonTapped:
                return .send(.delegate(.addAlarmTapped))
                
            case .settingButtonTapped:
                return .send(.delegate(.moveToSetting))
                
            case let .delegate(delegateAction):
                Logger.shared.log(category: .ui, "🟡 HomeFeature 자체 delegate: \(delegateAction)")
                return .none
                
                
            }
            
            
            
        }
        .forEach(\.card, action: \.card) {
            AlarmCardFeature()
        }
        
    }

}
