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
        
        var alarm: Alarm = .sampleData
        
    }
    
    public enum Action {
        case loginButtonTapped(SocialLoginType)
        case didFinishLogin(Result<SignInInfo, Error>)
        case delegate(Delegate)
        
        
        case bindingToggle(Bool)
    }
    
    public enum Delegate {
        case didFinishLogin(shouldCreateProfile: Bool)
    }
    
    @Dependency(\.authUsecase) var authUseCase
    @Dependency(\.appleRepository) var appleRepository
    @Dependency(\.kakaoRepository) var kakaoRepository
    @Dependency(\.googleRepository) var googleRepository
    
    public var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case let .loginButtonTapped(type):
                return .run { send in
                    await send(.didFinishLogin(
                        Result {
                            switch type {
                            case .apple:
                                try await authUseCase.signIn(appleRepository)
                            case .kakao:
                                try await authUseCase.signIn(kakaoRepository)
                            case .google:
                                try await authUseCase.signIn(googleRepository)
                            }
                        }
                    ))
                }
            case let .didFinishLogin(.success(info)):
                KeychainProvider.shared.save(info.accessToken, key: .accessToken)
                KeychainProvider.shared.save(info.refreshToken, key: .refreshToken)
                return .send(.delegate(.didFinishLogin(shouldCreateProfile: true)))
            case .didFinishLogin(.failure):
                return .none
            case .delegate:
                return .none
            case let .bindingToggle(onOff):
                state.alarm.isToggleOn = onOff
                return .none
            }
        }
    }
}

