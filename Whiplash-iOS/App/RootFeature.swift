//
//  RootFeature.swift
//  Whiplash-iOS
//
//  Created by 남경민 on 8/9/25.
//

import ComposableArchitecture

@Reducer
struct RootFeature {
    @ObservableState
    struct State: Equatable {
        var splash: SplashFeature.State? = .init()
        var onboarding: OnboardingFeature.State?
        var login: LoginFeature.State?
        var main: MainFeature.State?
    }
    
    @CasePathable
    enum Action: BindableAction {
        case splash(SplashFeature.Action)
        case onboarding(OnboardingFeature.Action)
        case login(LoginFeature.Action)
        case main(MainFeature.Action)
        case binding(BindingAction<State>)
    }
    
    @Dependency(\.onboardingClient) var onboardingClient
    @Dependency(\.authClient) var authClient
    
    var body: some Reducer<State, Action> {
        BindingReducer()
        
            .ifLet(\.splash,     action: \.splash)     { SplashFeature() }
            .ifLet(\.onboarding, action: \.onboarding) { OnboardingFeature() }
            .ifLet(\.login,      action: \.login)      { LoginFeature() }
            .ifLet(\.main,       action: \.main)       { MainFeature() }
        
        Reduce { state, action in
            switch action {
                
            case .splash(.delegate(.ready)):
                Logger.shared.log(level: .debug, category: .etc, "델리게이트 넘어옴")
                Logger.shared.log(level: .debug, category: .etc, "onboardingClient.hasSeen()\(onboardingClient.hasSeen())")
                if !onboardingClient.hasSeen()  {
                    Logger.shared.log(level: .debug, category: .etc, "온보딩 안 봄")
                    state.splash = nil
                    state.onboarding = .init()
                    return .none
                }

                return .run { send in
                    let ses = await authClient.sessionState()
                    Logger.shared.log(level: .debug, category: .etc, "authClient.sessionState() \(ses))")
                    await send(
                        ses == .valid
                        ? .login(.delegate(.didFinishLogin(shouldCreateProfile: false)))
                        : .login(.delegate(.needLogin))
                    )
                }

            case .onboarding(.delegate(.finished)):
                onboardingClient.setSeen(true)
                state.onboarding = nil
                state.login = .init()
                return .none

            case let .login(.delegate(.didFinishLogin(shouldCreateProfile))):
                Logger.shared.log(level: .debug, category: .etc, "홈화면")
                state.splash = nil
                state.login = nil
                state.main = .init()
                return .none
                
            case .login(.delegate(.needLogin)):
                Logger.shared.log(level: .debug, category: .etc, "로그인 화면")
                state.splash = nil
                state.onboarding = nil
                state.login = .init()
                state.main = nil
                return .none
            
            case .main(.delegate(.logout)):
                Logger.shared.log(level: .debug, category: .etc, "루트에서 로그아웃 수신됨")
                state.main = nil
                state.login = .init()
                return .none
                
            case .main(.delegate(.signout)):
                Logger.shared.log(level: .debug, category: .etc, "루트에서 회원탈퇴 수신됨")
                state.main = nil
                state.login = .init()
                return .none
                
            case .binding:
                return .none
                
            case .splash, .onboarding, .login, .main:
                return .none
            }
        }
    }
}
