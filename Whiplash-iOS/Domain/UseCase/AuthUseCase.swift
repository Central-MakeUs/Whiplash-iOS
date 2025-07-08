//
//  AuthUseCase.swift
//  Whiplash-iOS
//
//  Created by 남경민 on 7/8/25.
//

import Foundation
import ComposableArchitecture

public enum AuthUseCaseError: Error {
    case logoutFailed
}

public struct AuthUseCase {
    public var signIn: @Sendable (_ repository: AuthRepository, _ socialType: SocialLoginType) async throws -> SignInInfo
    public var logout: @Sendable (_ repository: AuthRepository, _ socialType: SocialLoginType) async throws -> Void

    public init(
        signIn: @escaping @Sendable (_ repository: AuthRepository, _ socialType: SocialLoginType) async throws -> SignInInfo,
        logout: @escaping @Sendable (_ repository: AuthRepository, _ socialType: SocialLoginType) async throws -> Void
    ) {
        self.signIn = signIn
        self.logout = logout
    }
}

extension AuthUseCase: DependencyKey {
    public static let liveValue: Self = {
        return Self(
            signIn: { repository, type in
                let response = try await repository.signIn(type)
                return response
            },
            logout: { repository, type in
                return try await repository.logout(type)
            }
        )
    }()
}
