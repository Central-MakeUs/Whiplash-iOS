//
//  AuthRepositoryImpl.swift
//  Whiplash-iOS
//
//  Created by 남경민 on 7/8/25.
//

import Foundation
import ComposableArchitecture
import Moya

public struct AppleAuthRepositoryImpl: AuthRepository {
    
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

extension AppleAuthRepositoryImpl: DependencyKey {
    
    public static let liveValue: Self = {
        let interceptor = AuthInterceptor()
        let apiClient = APIClient()
        
        return Self(
            signIn: {
                let identityToken = try await AppleAuthService().signIn()
                let endpoint = Endpoint<SignInResponseDTO>(
                    path: "api/auth/login/apple",
                    httpMethod: .post,
                    bodyParameters: SignInRequestDTO(identityToken: identityToken)
                )
                let response = await NetworkProvider.shared.sendRequest(endpoint, interceptor: nil)
                
                switch response {
                case .success(let response):
                    return response.toDomain
                case .failure(let error):
                    throw error
                }
                
                apiClient.request(SignInResponseDTO, target: .signIn)
                
            },
            logout: {
                let endpoint = Endpoint<Empty>(
                    path: "api/auth/logout",
                    httpMethod: .post
                )
                
                let response = await NetworkProvider.shared.sendRequest(endpoint, interceptor: interceptor)
                
                if case .failure(let failure) = response {
                    throw failure
                }
            }
        )
    }()
}

