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
    public struct State {
        public init() {}
        
        var alarm: [Alarm] = Alarm.sampleList
        
    }
    
    public enum Action {
        case onAppear
        case didFinishGetList(Result<[Alarm], Error>)
    }
    
    @Dependency(\.alarmRepository) var alarmRepository
    
    public var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
           
            case .onAppear:
                return .run { send in
                    await send(.didFinishGetList(
                        Result {
                            try await alarmRepository.getAlarmList()
                        }
                    ))
                }
                
            case let .didFinishGetList(.success(alarmList)):
                state.alarm = alarmList
                return .none
            case .didFinishGetList(.failure):
                return .none
            }
            
        }
    }
}

