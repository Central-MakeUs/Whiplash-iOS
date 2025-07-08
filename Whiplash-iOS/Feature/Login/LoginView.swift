//
//  LoginView.swift
//  Whiplash-iOS
//
//  Created by 남경민 on 7/8/25.
//

import SwiftUI

struct LoginView: View {
    var body: some View {
        ZStack {
            Color.gray900
                .ignoresSafeArea()
            VStack(spacing: 8) {
                
                Spacer()
                
                LoginButton(type: .apple) {
                    //
                }
                LoginButton(type: .kakao) {
                    //
                }
                LoginButton(type: .google) {
                    //
                }
                
                Spacer().frame(height: 94)
            }
            .padding(.horizontal, AppLayout.horizontalPadding)
        }
    }
}

#Preview {
    LoginView()
}
