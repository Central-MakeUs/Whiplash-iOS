//
//  MainFeature.swift
//  Whiplash-iOS
//
//  Created by 남경민 on 8/10/25.
//

import Foundation
import ComposableArchitecture

@Reducer
struct MainFeature {
    @ObservableState
    struct State: Equatable {
        var home = HomeFeature.State()
        var path = StackState<Path.State>()
    }
    
    @CasePathable
    enum Action: BindableAction {
        case home(HomeFeature.Action)
        case path(StackAction<Path.State, Path.Action>)
        case binding(BindingAction<State>)
    }
    
    struct Path: Reducer {
        enum State: Equatable {
            case setAlarm(SetAlarmFeature.State)
        }
        enum Action {
            case setAlarm(SetAlarmFeature.Action)
        }
        var body: some ReducerOf<Self> {
            Scope(state: /State.setAlarm, action: /Action.setAlarm) {
                SetAlarmFeature()
            }
        }
    }
    
    var body: some ReducerOf<Self> {
        BindingReducer()
        
        Scope(state: \.home, action: \.home) {
            HomeFeature()
        }
        
        Reduce { state, action in
            switch action {
            case .home(.delegate(.addAlarmTapped)):
                state.path.append(.setAlarm(.init()))
                return .none
                
            case .path(.element(_, action: .setAlarm(.delegate(.didCreateAlarm)))):
                state.path.popLast()
                return .send(.home(.onAppear))
                
            case .path, .home:
                return .none
                
            case .binding(_):
                return .none
            }
        }
        .forEach(\.path, action: \.path) {
            Path()
        }
    }
}

@Reducer
struct Destination {
    @ObservableState
    enum State: Equatable {
        case setAlarm(SetAlarmFeature.State)
    }
    
    @CasePathable
    enum Action {
        case setAlarm(SetAlarmFeature.Action)
    }
    
    var body: some ReducerOf<Self> {
        Scope(state: \.setAlarm, action: \.setAlarm) {
            SetAlarmFeature()
        }
    }
}
