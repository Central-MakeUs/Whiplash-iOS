//
//  KakaoAuthService.swift
//  Whiplash-iOS
//
//  Created by 남경민 on 7/8/25.
//

import Foundation
import KakaoSDKAuth
import KakaoSDKUser

final class KakaoAuthService: NSObject {
    
    func signIn() async throws -> String {
        return try await withCheckedThrowingContinuation { continuation in
            if UserApi.isKakaoTalkLoginAvailable() {
                UserApi.shared.loginWithKakaoTalk { oauthToken, error in
                    if let token = oauthToken?.accessToken {
                        continuation.resume(returning: token)
                    } else if let error = error {
                        continuation.resume(throwing: error)
                    }
                }
            } else {
                UserApi.shared.loginWithKakaoAccount { oauthToken, error in
                    if let token = oauthToken?.accessToken {
                        continuation.resume(returning: token)
                    } else if let error = error {
                        continuation.resume(throwing: error)
                    }
                }
            }
        }
    }
    
}
