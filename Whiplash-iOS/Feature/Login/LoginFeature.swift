//
//  LoginFeature.swift
//  Whiplash-iOS
//
//  Created by 남경민 on 7/8/25.
//

import Foundation
import ComposableArchitecture

@Reducer
public struct LoginFeature {
    
    public init() {}
    
    @ObservableState
    public struct State: Equatable {
        public init() {}
    }
    
    public enum Action {
        case loginButtonTapped(SocialLoginType)
        case didFinishLogin(Result<SignInInfo, Error>)
        case delegate(Delegate)
    }
    
    public enum Delegate {
        case didFinishLogin(shouldCreateProfile: Bool)
    }
    
    @Dependency(\.authUsecase) var authUseCase
    @Dependency(\.appleRepository) var appleRepository
    
    public var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case let .loginButtonTapped(type):
                return .run { send in
                    await send(.didFinishLogin(
                        Result {
                            try await authUseCase.signIn(appleRepository)
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
            }
        }
    }
}
