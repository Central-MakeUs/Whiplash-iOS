//
//  GoogleAuthRepository.swift
//  Whiplash-iOS
//
//  Created by 남경민 on 8/1/25.
//

import Foundation
import ComposableArchitecture
import Moya
import UIKit

public struct GoogleAuthRepositoryImpl: AuthRepository {
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

extension GoogleAuthRepositoryImpl: DependencyKey {
    public static let liveValue: Self = {
        let apiClient = APIClient()
        return Self(
            signIn: { 
                let idToken = try await GoogleAuthService.shared.signIn()

                let request = SignInRequestDTO(socialType: "GOOGLE",
                                               token: idToken,
                                               deviceId: "1")
                
                let response: Response<SignInResponseDTO> = try await apiClient.request(
                    Response<SignInResponseDTO>.self,
                    target: .signIn(request)
                )
                if response.isSuccess, let data = response.result {
                    return data.toDomain
                } else {
                    throw NSError(domain: "SignIn", code: 0, userInfo: [NSLocalizedDescriptionKey: response.message])
                }
            },
            logout: {
            }
        )
    }()
}
