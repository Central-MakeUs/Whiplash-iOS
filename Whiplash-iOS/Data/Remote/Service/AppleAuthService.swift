//
//  AppleAuthService.swift
//  Whiplash-iOS
//
//  Created by 남경민 on 7/8/25.
//

import Foundation
import AuthenticationServices
import CryptoKit

final class AppleAuthService: NSObject {
    
    typealias IdentityToken = String
    
    func signIn() async throws -> IdentityToken {
        try await withCheckedThrowingContinuation { continuation in
            let appleIDProvider = ASAuthorizationAppleIDProvider()
            let request = appleIDProvider.createRequest()

            request.requestedScopes = [.fullName, .email]
            let nonce = randomNonceString()
            request.nonce = sha256(nonce)
            
            let authorizationController = ASAuthorizationController(authorizationRequests: [request])
            authorizationController.delegate = self
            authorizationController.performRequests()
            
            if self.continuation == nil {
                self.continuation = continuation
            }
        }
    }
    
    // MARK: Private
    private var continuation: CheckedContinuation<IdentityToken, Error>?
}

private extension AppleAuthService {
    
    enum AppleLoginError: LocalizedError {
        case invalidCredential
        case invalidIdentityToken
        case invalidAuthorizationCode
        case transferError(Error)
    }
}

// MARK: - ASAuthorizationControllerDelegate
extension AppleAuthService: ASAuthorizationControllerDelegate {
    
    func authorizationController(
        controller: ASAuthorizationController,
        didCompleteWithAuthorization authorization: ASAuthorization
    ) {
        guard let credential = authorization.credential as? ASAuthorizationAppleIDCredential else {
            continuation?.resume(throwing: AppleLoginError.invalidCredential)
            continuation = nil
            return
        }
        
        guard let tokenData = credential.identityToken,
              let token = IdentityToken(data: tokenData, encoding: .utf8) else {
            continuation?.resume(throwing: AppleLoginError.invalidIdentityToken)
            continuation = nil
            return
        }
        
        guard let authorizationCode = credential.authorizationCode,
              let _ = String(data: authorizationCode, encoding: .utf8) else {
            continuation?.resume(throwing: AppleLoginError.invalidAuthorizationCode)
            continuation = nil
            return
        }
        
        continuation?.resume(returning: token)
        continuation = nil
    }
    
    func authorizationController(
        controller: ASAuthorizationController,
        didCompleteWithError error: Error
    ) {
        continuation?.resume(throwing: error)
        continuation = nil
    }
}

extension AppleAuthService {
    
    private func randomNonceString(length: Int = 32) -> String {
        precondition(length > 0)
        let charset: [Character] =
        Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
        var result = ""
        var remainingLength = length
        
        while remainingLength > 0 {
            let randoms: [UInt8] = (0 ..< 16).map { _ in
                var random: UInt8 = 0
                let errorCode = SecRandomCopyBytes(kSecRandomDefault, 1, &random)
                if errorCode != errSecSuccess {
                    fatalError(
                        "Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)"
                    )
                }
                return random
            }
            
            randoms.forEach { random in
                if remainingLength == 0 {
                    return
                }
                
                if random < charset.count {
                    result.append(charset[Int(random)])
                    remainingLength -= 1
                }
                
            }
        }
        
        return result
        
    }
    
    private func sha256(_ input: String) -> String {
        let inputData = Data(input.utf8)
        let hashedData = SHA256.hash(data: inputData)
        let hashString = hashedData.compactMap {
            String(format: "%02x", $0)
        }.joined()
        
        return hashString
    }
}
