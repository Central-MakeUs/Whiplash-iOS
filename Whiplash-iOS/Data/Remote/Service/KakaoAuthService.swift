//
//  KakaoAuthService.swift
//  Whiplash-iOS
//
//  Created by 남경민 on 7/8/25.
//

import Foundation
import KakaoSDKAuth
import KakaoSDKUser

@MainActor
final class KakaoAuthService: NSObject {

    func signIn() async throws -> String {
        try Task.checkCancellation()

        return try await withCheckedThrowingContinuation { continuation in
            // 중복 resume 방지
            var didResume = false
            func resumeOnce(_ block: () -> Void) {
                guard !didResume else { return }
                didResume = true
                block()
            }

            let handle: (OAuthToken?, Error?) -> Void = { oauthToken, error in
                if let token = oauthToken?.accessToken {
                    resumeOnce { continuation.resume(returning: token) }
                } else if let error = error {
                    resumeOnce { continuation.resume(throwing: error) }
                } else {
                    resumeOnce { continuation.resume(throwing: CancellationError()) }
                }
            }

            if UserApi.isKakaoTalkLoginAvailable() {
                UserApi.shared.loginWithKakaoTalk(completion: handle)
            } else {
                UserApi.shared.loginWithKakaoAccount(completion: handle)
            }
        }
    }
}
