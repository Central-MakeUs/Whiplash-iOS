//
//  ContentView.swift
//  Whiplash-iOS
//
//  Created by 남경민 on 6/24/25.
//

import SwiftUI
import ComposableArchitecture

/*/
struct AppRouterView: View {
    @Bindable var store: StoreOf<AppFeature>
    
    var body: some View {
        WithPerceptionTracking {
            Group {
                switch store.phase {
                case .splash:
                    IfCaseLetStore(store, state: /AppFeature.State.Phase.splash,
                                   action: AppFeature.Action.splash, then: SplashView.init)
                case .onboarding:
                    IfCaseLetStore(store, state: /AppFeature.State.Phase.onboarding,
                                   action: AppFeature.Action.onboarding, then: OnboardingView.init)
                case .auth:
                    IfCaseLetStore(store, state: /AppFeature.State.Phase.auth,
                                   action: AppFeature.Action.auth, then: LoginView.init)
                case .main:
                    // 중앙 스택을 쓰고 싶다면 여기서 NavigationStackStore로 store.path 연결
                    MainView(store: store.scope(state: /AppFeature.State.Phase.main,
                                                action: AppFeature.Action.main))
                }
            }
            .sheet(item: $store.sheet) { sheet in
                switch sheet {
                case .confirmMyLocation: ConfirmLocationSheet()
                case .verifying:         VerifyingSheet()
                }
            }
            .fullScreenCover(item: $store.fullScreen) { full in
                switch full {
                case let .alarmRinging(state): AlarmRingingView(store: .init(initialState: state, reducer: { AlarmRingingFeature() }))
                }
            }
            .alert(store: store.scope(state: \.alert), dismiss: .router(.showAlert(nil)))
            .overlay(alignment: .top) { GlobalToastView(state: store.toast) }
        }
    }
}
*/
