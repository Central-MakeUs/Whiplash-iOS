//
//  LoginView.swift
//  Whiplash-iOS
//
//  Created by 남경민 on 7/8/25.
//

import SwiftUI
import ComposableArchitecture

struct LoginView: View {
    let store: StoreOf<LoginFeature>
    
    init(store: StoreOf<LoginFeature>) {
        self.store = store
    }
    
    var body: some View {
        ZStack {
            Color.gray900
                .ignoresSafeArea()
            VStack(spacing: 8) {
                
                Spacer()
                
                Image(.Image.appLogo)
                
                Spacer()
                
                LoginButton(type: .kakao) {
                    store.send(.loginButtonTapped(.kakao))
                }
                
                LoginButton(type: .google) {
                    store.send(.loginButtonTapped(.google))
                }
                
                LoginButton(type: .apple) {
                    store.send(.loginButtonTapped(.apple))
                }
                
                
                Spacer().frame(height: 94)
            }
            .padding(.horizontal, AppLayout.horizontalPadding)
        }
    }
}

#Preview {
    LoginView(store: Store(initialState: LoginFeature.State(),
                           reducer: { LoginFeature() })
    )
}
