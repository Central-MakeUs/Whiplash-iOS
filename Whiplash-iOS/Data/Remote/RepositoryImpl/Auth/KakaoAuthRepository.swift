//
//  KakaoAuthRepository.swift
//  Whiplash-iOS
//
//  Created by 남경민 on 8/1/25.
//

import Foundation
import ComposableArchitecture
import Moya

public struct KakaoAuthRepositoryImpl: AuthRepository {
    
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

extension KakaoAuthRepositoryImpl: DependencyKey {
    
    public static let liveValue: Self = {
        let apiClient = APIClient()
        
        return Self(
            signIn: {
                let token = try await KakaoAuthService().signIn()
                let request = SignInRequestDTO(socialType: "KAKAO",
                                               token: token,
                                               deviceId: "3")
                
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
                
            }
        )
    }()
}

