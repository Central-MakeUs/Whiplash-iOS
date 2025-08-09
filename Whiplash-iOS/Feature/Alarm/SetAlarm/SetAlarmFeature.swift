//
//  SetAlarmFeature.swift
//  Whiplash-iOS
//
//  Created by 남경민 on 8/10/25.
//

import Foundation
import ComposableArchitecture

@Reducer
public struct SetAlarmFeature {
    public init() {}
    
    @ObservableState
    public struct State: Equatable {
        public init() {}
        // 여기에 입력 값들(시간/장소/목적 등) 상태를 점차 옮겨오면 됨
    }
    
    public enum Action: Equatable {
        case onAppear
        case saveTapped
        case closeTapped
        case delegate(Delegate)
        public enum Delegate: Equatable {
            case didCreateAlarm  // 저장 완료 후 부모에게 알림
        }
    }
    
    public var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .onAppear:
                return .none
            case .saveTapped:
                // TODO: 저장 API 호출 후 성공 시 delegate로 알리기
                return .send(.delegate(.didCreateAlarm))
            case .closeTapped:
                return .none
            case .delegate:
                return .none
            }
        }
    }
}
