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
    public var signout: @Sendable () async throws -> Void
    
    public init(
        signIn: @escaping @Sendable () async throws -> SignInInfo,
        logout: @escaping @Sendable () async throws -> Void,
        signout: @escaping @Sendable () async throws -> Void
    ) {
        self.signIn = signIn
        self.logout = logout
        self.signout = signout
    }
}

extension AppleAuthRepositoryImpl: DependencyKey {
    
    public static let liveValue: Self = {
        let apiClient = APIClient()
        
        return Self(
            signIn: {
                let identityToken = try await AppleAuthService().signIn()
                let request = SignInRequestDTO(socialType: "APPLE",
                                               token: identityToken,
                                               deviceId: "1")
                
                let response: Response<SignInResponseDTO> = try await apiClient.request(
                    Response<SignInResponseDTO>.self,
                    target: .signIn(request))
                
                if response.isSuccess, let dto = response.result {
                    
                    return dto.toDomain
                    
                } else {
                    throw NSError(domain: "SignIn", code: 0, userInfo: [NSLocalizedDescriptionKey: response.message])
                }

            },
            logout: {
                let response: Response<EmptyDTO> = try await apiClient.request(
                    Response<EmptyDTO>.self,
                    target: .logout)
                
                if response.isSuccess {
                    
                    return
                    
                } else {
                    throw NSError(domain: "logout", code: 0, userInfo: [NSLocalizedDescriptionKey: response.message])
                }
            },
            signout: {
                let response: Response<EmptyDTO> = try await apiClient.request(
                    Response<EmptyDTO>.self,
                    target: .signout)
                
                if response.isSuccess {
                    
                    return
                    
                } else {
                    throw NSError(domain: "signout", code: 0, userInfo: [NSLocalizedDescriptionKey: response.message])
                }
            }
        )
    }()
}

