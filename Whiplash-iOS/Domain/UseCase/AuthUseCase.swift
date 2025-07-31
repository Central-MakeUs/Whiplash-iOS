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
    public var signIn: @Sendable (_ repository: AuthRepository) async throws -> SignInInfo
    public var logout: @Sendable (_ repository: AuthRepository) async throws -> Void

    public init(
        signIn: @escaping @Sendable (_ repository: AuthRepository) async throws -> SignInInfo,
        logout: @escaping @Sendable (_ repository: AuthRepository) async throws -> Void
    ) {
        self.signIn = signIn
        self.logout = logout
    }
}

extension AuthUseCase: DependencyKey {
    public static let liveValue: Self = {
        return Self(
            signIn: { repository in
                let response = try await repository.signIn()
                return response
            },
            logout: { repository in
                return try await repository.logout()
            }
        )
    }()
}
