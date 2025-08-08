//
//  SplashFeature.swift
//  Whiplash-iOS
//
//  Created by 남경민 on 8/9/25.
//

import Foundation
import ComposableArchitecture
/*
@Reducer
struct SplashFeature {
    @ObservableState
    struct State: Equatable { var isLoading = true }
    
    enum Action: Equatable {
        case onAppear
        case _minHoldDone
        case _decideRoute
        case delegate(Delegate)
        enum Delegate: Equatable { case goOnboarding, goAuth, goMain }
    }
    
    @Dependency(\.appSettings) var settings        // isFirstLaunch 등
    @Dependency(\.autoLoginClient) var autoLogin
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .onAppear:
                return .merge(
                    .run { send in
                        try await clock.sleep(for: .milliseconds(800))
                        await send(._minHoldDone)
                    },
                    .send(._decideRoute)
                )
                
            case ._minHoldDone:
                state.isLoading = false
                return .none
                
            case ._decideRoute:
                return .run { send in
                    let first = await settings.isFirstLaunch()
                    if first {
                        await send(.delegate(.goOnboarding)); return
                    }
                    
                    let autoOn = autoLogin.isEnabled()
                    let hasTokens = tokenStore.load() != nil
                    
                    if autoOn && hasTokens {
                        // 바로 메인 진입. 액세스 만료/401은 인터셉터가 잡아 리프레시 시도.
                        await send(.delegate(.goMain))
                    } else {
                        await send(.delegate(.goAuth))
                    }
                }
            }
        }
    }
}

*/
