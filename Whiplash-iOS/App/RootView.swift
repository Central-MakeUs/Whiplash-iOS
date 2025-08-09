//
//  ContentView.swift
//  Whiplash-iOS
//
//  Created by 남경민 on 6/24/25.
//

import SwiftUI
import ComposableArchitecture

struct RootView: View {
    @Bindable var store: StoreOf<RootFeature>
    
    var body: some View {
        ZStack {
            if let s = store.scope(state: \.splash, action: \.splash) {
                SplashView(store: s)
            } else if let s = store.scope(state: \.onboarding, action: \.onboarding) {
                OnboardingView(store: s)
            } else if let s = store.scope(state: \.login, action: \.login) {
                LoginView(store: s)
                    .onOpenURL { url in
                        _ = AppURLRouter.route(url)
                    }
            } else if let s = store.scope(state: \.home, action: \.home) {
                HomeView(store: s)
            } else {
                Color.clear.onAppear { store.send(.splash(.onAppear)) }
            }
        }
        
    }
}
