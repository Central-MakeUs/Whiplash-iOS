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
        case appleLoginButtonTapped
        case didFinishLogin(Result<SignInInfo, Error>)
        case delegate(Delegate)
    }
    
    public enum Delegate {
        case didFinishLogin
    }
    
    @Dependency(AuthUseCase.self) var authUseCase
    
    public var body: some ReducerOf<Self> {
        Reduce<State, Action> { state, action in
            switch action {
            case .appleLoginButtonTapped:
                return .run { send in
                    await send(.didFinishLogin(
                        Result {
                            try await authUseCase.signIn()//apple repository 넘기기
                        }
                    ))
                }
            case let .didFinishLogin(.success(response)):
                KeychainProvider.shared.save(response.accessToken, key: .accessToken)
                KeychainProvider.shared.save(response.refreshToken, key: .refreshToken)
                return .send(.delegate(.didFinishLogin())) // 필요한 정보 설정
            case .didFinishLogin(.failure):
                return .none
            case .delegate:
                return .none
            }
        }
    }
}
