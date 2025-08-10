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
        var place: Place = .emptyData
        var alarm: Alarm = .emptyData
    }
    
    public enum Action: Equatable, BindableAction {
        case onAppear
        case saveTapped
        case closeTapped
        case searchBarTapped
        case backButtonTapped
        case binding(BindingAction<State>)
        case selectedPlaceName(String)
        case alarmTitle(String)
        case delegate(Delegate)
        public enum Delegate: Equatable {
            case didCreateAlarm  // 저장 완료 후 부모에게 알림
            case searchPlace
            case backButtonTapped
        }
    }
    
    public var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .onAppear:
                return .none
            case .saveTapped:
                return .send(.delegate(.didCreateAlarm))
            case .searchBarTapped:
                return .send(.delegate(.searchPlace))
            case .closeTapped:
                return .none
            case .backButtonTapped:
                return .send(.delegate(.backButtonTapped))
            case .delegate:
                return .none
            case let .alarmTitle(title):
                state.alarm.title = title
                return .none
            case let .selectedPlaceName(name):
                state.place.name = name
                return .none
            case .binding(_):
                return .none
            }
        }
    }
}
