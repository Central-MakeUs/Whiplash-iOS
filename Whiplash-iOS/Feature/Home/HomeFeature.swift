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
        var cards: IdentifiedArrayOf<AlarmCardFeature.State> = []
    }
    
    public enum Action {
        case onAppear
        case didFinishGetList(Result<[Alarm], Error>)
        case card(IdentifiedActionOf<AlarmCardFeature>)
        case logoutTapped
        case delegate(Delegate)
        
        public enum Delegate: Equatable {
            case logout
        }
    }
    
    @Dependency(\.alarmRepository) var alarmRepository
    
    public var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
                
            case .onAppear:
                Logger.shared.log(category: .ui, "HomeFeature.onAppear 호출됨")
                return .run { send in
                    Logger.shared.log(category: .network, "알람 리스트 요청 시작")
                    let result = await Result {
                        try await alarmRepository.getAlarmList()
                    }
                    Logger.shared.log(category: .network, "알람 리스트 요청 완료 → \(result)")
                    await send(.didFinishGetList(result))
                }
                
            case let .didFinishGetList(.success(alarmList)):
                Logger.shared.log(category: .database, "알람 리스트 수신 성공 → \(alarmList.count)개")
                state.cards = IdentifiedArray(uniqueElements: alarmList.map { AlarmCardFeature.State(alarm: $0) })
                return .none
                
            case let .didFinishGetList(.failure(error)):
                Logger.shared.log(level: .error, category: .network, "알람 리스트 요청 실패 → \(error.localizedDescription)")
                return .none
                
            case .card:
                return .none
                
            case .logoutTapped:
                return .send(.delegate(.logout))
                
            case .delegate:
                return .none
            }
        }
        .forEach(\.cards, action: \.card) {
            AlarmCardFeature()
        }
    }
}
