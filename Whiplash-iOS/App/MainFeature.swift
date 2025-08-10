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
            case searchPlace(SearchPlaceFeature.State)
            case map(MapFeature.State)
        }
        enum Action {
            case setAlarm(SetAlarmFeature.Action)
            case searchPlace(SearchPlaceFeature.Action)
            case map(MapFeature.Action)
        }
        var body: some ReducerOf<Self> {
            Scope(state: /State.setAlarm, action: /Action.setAlarm) {
                SetAlarmFeature()
            }
            Scope(state: /State.searchPlace, action: /Action.searchPlace) {
                SearchPlaceFeature()
            }
            Scope(state: /State.map, action: /Action.map){
                MapFeature()
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
            
            case .path(.element(_, action: .setAlarm(.delegate(.searchPlace)))):
                state.path.append(.searchPlace(.init()))
                return .send(.home(.onAppear))
                
            case .path(.element(_, action: .searchPlace(.delegate(.backButtonTapped)))):
                state.path.popLast()
                return .send(.home(.onAppear))
                
            case .path(.element(_, action: .setAlarm(.delegate(.didCreateAlarm)))):
                state.path.popLast()
                return .send(.home(.onAppear))
            
            case .path(.element(_, action: .setAlarm(.delegate(.backButtonTapped)))):
                state.path.popLast()
                return .send(.home(.onAppear))
                // ✅ SearchPlace에서 장소 선택 → Map 화면 푸시
            case let .path(.element(_, action: .searchPlace(.delegate(.didSelectPlace(mapStyle))))):
                state.path.append(.map(.init(
                    mapStyle: mapStyle            // 넘길 타이틀
                )))
                return .none
                
                // SearchPlace 뒤로 버튼 → pop
            case .path(.element(_, action: .searchPlace(.delegate(.backButtonTapped)))):
                state.path.popLast()
                return .none
                
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
