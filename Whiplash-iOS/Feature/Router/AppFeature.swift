//
//  AppFeature.swift
//  Whiplash-iOS
//
//  Created by 남경민 on 8/2/25.
//
/*
import Foundation
import ComposableArchitecture

@Reducer
struct AppFeature {
    @ObservableState
    struct State: Equatable {
        // 앱 페이즈 (스플래시/온보딩/인증/메인)
        enum Phase: Equatable {
            case splash(SplashFeature.State)
            case onboarding(OnboardingFeature.State)
            case auth(LoginFeature.State)
            case main(MainFeature.State)
        }
        var phase: Phase = .splash(.init())
        
        // 공통 프레젠테이션
        @PresentationState var sheet: Sheet?
        @PresentationState var modal: Modal?
        @PresentationState var fullScreen: FullScreen?
        var alert: AlertState<Action>?
        var toast: ToastState?
        
        // (선택) 전역 NavigationStack 이 필요하면 여기에 둔다
        var path = StackState<Route.State>()
    }
    
    // 열리는 것들 전부 한곳에서
    enum Sheet: Equatable, Identifiable {
        case confirmMyLocation
        case verifying
        var id: String { String(reflecting: self) }
    }
    enum Modal: Equatable, Identifiable {
        case placePicker(PlacePickerFeature.State)
        var id: String { String(reflecting: self) }
    }
    enum FullScreen: Equatable, Identifiable {
        case alarmRinging(AlarmRingingFeature.State)
        var id: String { String(reflecting: self) }
    }
    
    /// **전 화면이 올릴 수 있는 고수준 라우팅 이벤트**
    enum RouterEvent: Equatable {
        // 페이즈
        case toOnboarding, toAuth, toMain
        // 네비게이션(push/pop)
        case push(Route.State)
        case pop, popToRoot
        // 프레젠테이션
        case presentSheet(Sheet?), presentModal(Modal?), presentFull(FullScreen?)
        case showAlert(AlertState<Action>?), showToast(String)
        // 세션/보안 등 전역
        case signedOut, tokenRefreshed, unauthorized
        // 딥링크
        case openDeepLink(DeepLink)
    }
    
    enum Action: Equatable {
        // 자식 액션
        case splash(SplashFeature.Action)
        case onboarding(OnboardingFeature.Action)
        case auth(LoginFeature.Action)
        case main(MainFeature.Action)
        case route(StackAction<Route.State, Route.Action>)
        
        // 중앙 라우터 이벤트
        case router(RouterEvent)
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
                
            case let .router(event):
                switch event {
                case .toOnboarding:
                    state.phase = .onboarding(.init()); return .none
                case .toAuth:
                    state.phase = .auth(.init());       return .none
                case .toMain:
                    state.phase = .main(.init());       return .none
                    
                case let .push(screen):
                    state.path.append(screen);          return .none
                case .pop:
                    _ = state.path.popLast();           return .none
                case .popToRoot:
                    state.path.removeAll();             return .none
                    
                case let .presentSheet(s):
                    state.sheet = s;                    return .none
                case let .presentModal(m):
                    state.modal = m;                    return .none
                case let .presentFull(f):
                    state.fullScreen = f;               return .none
                    
                case let .showAlert(a):
                    state.alert = a;                    return .none
                case let .showToast(msg):
                    state.toast = .init(message: msg, style: .info, duration: 2); return .none
                    
                case .signedOut, .unauthorized:
                    // 토큰 삭제/환경 초기화 등 공통 처리 후 인증 화면으로
                    state.sheet = nil; state.modal = nil; state.fullScreen = nil
                    state.path.removeAll()
                    state.phase = .auth(.init())
                    return .none
                    
                case .tokenRefreshed:
                    return .none
                    
                case let .openDeepLink(link):
                    // 딥링크 → Route.State로 매핑해서 push 또는 phase 전환
                    if let route = Route.State(deepLink: link) {
                        state.path = [route]              // 또는 append
                    }
                    return .none
                }
                
                // === 자식 → delegate → 중앙으로 승격 ===
            case .splash(.delegate(.goOnboarding)):
                return .send(.router(.toOnboarding))
            case .splash(.delegate(.goAuth)):
                return .send(.router(.toAuth))
            case .splash(.delegate(.goMain)):
                return .send(.router(.toMain))
                
            case .onboarding(.delegate(.completed)):
                return .send(.router(.toAuth)) // 정책에 따라 .toMain 로도 가능
                
            case .auth(.delegate(.loggedIn)):
                return .send(.router(.toMain))
                
            case .main(.delegate(.openPlacePicker)):
                return .send(.router(.presentModal(.placePicker(.init()))))
                
            default:
                return .none
            }
        }
        // 페이즈 연결
        .ifCaseLet(/State.Phase.splash, action: /Action.splash) { SplashFeature() }
        .ifCaseLet(/State.Phase.onboarding, action: /Action.onboarding) { OnboardingFeature() }
        .ifCaseLet(/State.Phase.auth, action: /Action.auth) { LoginFeature() }
        .ifCaseLet(/State.Phase.main, action: /Action.main) { MainFeature() }
        // 스택 연결(필요 시)
        .forEach(\.path, action: /Action.route) { Route() }
        // 프레젠테이션 연결(필요 시)
        .ifLet(\.$modal, action: .init(/Action.router).appending(path: /RouterEvent.presentModal)) {
            // 모달 내부를 TCA로 관리하려면 여기 연결
            Reduce { _,_ in .none }
        }
    }
}
*/
