//
//  OnboardingFeature.swift
//  Whiplash-iOS
//
//  Created by 남경민 on 8/9/25.
//

import Foundation
import ComposableArchitecture

@Reducer
struct OnboardingFeature {
    @ObservableState
    struct State: Equatable {
        var currentPage: Int = 0
        let totalPages: Int = 4
    }

    enum Action: BindableAction, Equatable {
        case binding(BindingAction<State>)
        case onAppear
        case pageChanged(Int)
        case nextTapped
        case backTapped
        case skipTapped
        case startTapped
        case delegate(Delegate)

        enum Delegate: Equatable {
            case finished // 온보딩 종료 -> AppFeature로 알림
        }
    }

    @Dependency(\.onboardingClient) var onboardingClient

    var body: some ReducerOf<Self> {
        BindingReducer()

        Reduce { state, action in
            switch action {
            case .onAppear:
                // 필요 시 analytics 등
                return .none

            case let .pageChanged(index):
                state.currentPage = index
                return .none

            case .nextTapped:
                if state.currentPage < state.totalPages - 1 {
                    state.currentPage += 1
                    return .none
                } else {
                    return .send(.startTapped)
                }

            case .backTapped:
                if state.currentPage > 0 { state.currentPage -= 1 }
                return .none

            case .skipTapped:
                state.currentPage = state.totalPages - 1
                return .none

            case .startTapped:
                onboardingClient.setSeen(true)
                return .send(.delegate(.finished))

            case .binding:
                return .none

            case .delegate:
                return .none
            }
        }
    }
}
