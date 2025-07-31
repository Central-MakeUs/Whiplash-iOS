//
//  AuthRepositoryImpl.swift
//  Whiplash-iOS
//
//  Created by 남경민 on 7/8/25.
//

import Foundation
import ComposableArchitecture

/*
public final class AuthRepositoryImpl: AuthRepository {
    private let apiClient: APIClient
    private let loginServices: [SocialLoginType: any AuthRepository]

    public init(apiClient: APIClient,
                loginServices: [SocialLoginType: any AuthRepository]) {
        self.apiClient = apiClient
        self.loginServices = loginServices
    }

    public func signIn(with type: SocialLoginType) async throws -> SignInInfo {
        guard let service = loginServices[type] else {
            throw NSError(domain: "LoginServiceNotFound", code: 0)
        }

        let token = try await service.login()
        let request = SignInRequestDTO(identityToken: token)
        let response: SignInResponseDTO = try await apiClient.request(target: AuthTarget.signIn(dto))
        return response.toDomain()
    }

    public func logout() async throws {
        //_ = try await apiClient.request(target: .logout) as EmptyResponse
    }
}*/


public struct AuthRepositoryImpl: AuthRepository {
    
    public var signIn: @Sendable () async throws -> SignInInfo
    public var logout: @Sendable () async throws -> Void
    
    public init(
        signIn: @escaping @Sendable () async throws -> SignInInfo,
        logout: @escaping @Sendable () async throws -> Void
    ) {
        self.signIn = signIn
        self.logout = logout
    }
}

extension AuthRepositoryImpl: DependencyKey {
    
    public static let liveValue: Self = {
        let interceptor = AuthInterceptor()

        return Self(
            signIn: {
               
            },
            logout: {
                
            }
        )
    }()
}

