//
//  LoginButton.swift
//  Whiplash-iOS
//
//  Created by 남경민 on 7/6/25.
//

import SwiftUI

struct LoginButton: View {
    let type: SocialLoginType
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 4) {
                type.icon

                BaseText(text: type.title,
                         style: .body2_m_14,
                         color: type.foregroundColor)
            }
            .padding(.horizontal, 24)
            .frame(maxWidth: .infinity)
            .frame(height: 44)
            .background(type.backgroundColor)
            .cornerRadius(4)
            .overlay(
                RoundedRectangle(cornerRadius: 4)
                    .stroke(type == .apple ? Color.gray5 : .clear,
                            lineWidth: 1)
            )
        }
    }
}

enum SocialLoginType {
    case google
    case apple
    case kakao

    var title: String {
        switch self {
        case .google: return "Google로 계속하기"
        case .apple: return "Apple로 계속하기"
        case .kakao: return "카카오로 계속하기"
        }
    }

    var backgroundColor: Color {
        switch self {
        case .google: return .white
        case .apple: return .black
        case .kakao: return Color.kakao
        }
    }

    var foregroundColor: Color {
        switch self {
        case .google: return .black
        case .apple: return .white
        case .kakao: return Color.kakaoLabel
        }
    }

    var icon: Image {
        switch self {
        case .google: return Image(.Image.icGoogle22)
        case .apple: return Image(.Image.icApple22)
        case .kakao: return Image(.Image.icKakao22)
        }
    }
}
