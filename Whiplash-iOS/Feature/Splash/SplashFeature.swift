//
//  SplashFeature.swift
//  Whiplash-iOS
//
//  Created by 남경민 on 8/9/25.
//

import Foundation
import ComposableArchitecture

@Reducer
struct SplashFeature {
    @ObservableState
    struct State: Equatable { var isAnimating = true }
    
    enum Action: Equatable {
        case onAppear, animationDone
        case delegate(Delegate)
        enum Delegate: Equatable {
            case ready
        }
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .onAppear:
                return .run { send in
                    try? await Task.sleep(nanoseconds: 600_000_000)
                    Logger.shared.log(level: .debug, category: .etc, "스플래시 4초 지남")
                    await send(.animationDone)
                }
            case .animationDone:
                return .send(.delegate(.ready))
            case .delegate:
                return .none
            }
        }
    }
}
