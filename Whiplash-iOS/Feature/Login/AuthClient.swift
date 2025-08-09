//
//  AuthClient.swift
//  Whiplash-iOS
//
//  Created by 남경민 on 8/9/25.
//

import ComposableArchitecture

enum SessionState: Equatable {
    case valid
    case needLogin
}

struct AuthClient {
    var sessionState: @Sendable () async -> SessionState
    var signOut: @Sendable () async -> Void
}

extension AuthClient: DependencyKey {
    static let liveValue = Self(
        sessionState: {
            
            if TokenStore().accessToken() != nil { return .valid }
            return .needLogin
        },
        signOut: {
            TokenStore().clear()
        }
    )
}

extension DependencyValues {
    var authClient: AuthClient {
        get { self[AuthClient.self] }
        set { self[AuthClient.self] = newValue }
    }
}
