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
        @Presents var destination: Destination.State?
    }
    
    @CasePathable
    enum Action: BindableAction {
        case home(HomeFeature.Action)
        case destination(PresentationAction<Destination.Action>)
        case binding(BindingAction<State>)
    }
    
    var body: some ReducerOf<Self> {
        BindingReducer()
        
        Scope(state: \.home, action: \.home) {
            HomeFeature()
        }
        
        Reduce { state, action in
            switch action {
            case .home(.delegate(.addAlarmTapped)):
                state.destination = .setAlarm(.init())
                return .none
                
            case .destination(.presented(.setAlarm(.delegate(.didCreateAlarm)))):
                state.destination = nil 
                return .send(.home(.onAppear))
                
            case .destination(.dismiss):
                state.destination = nil
                return .none
                
            case .destination, .home:
                return .none
                
            case .binding(_):
                return .none
            }
        }
        .ifLet(\.$destination, action: \.destination) {
            Destination()
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
