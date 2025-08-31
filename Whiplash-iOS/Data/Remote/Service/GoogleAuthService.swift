//
//  GoogleAuthService.swift
//  Whiplash-iOS
//
//  Created by 남경민 on 7/8/25.
//

import Foundation
import GoogleSignIn
import UIKit

@MainActor
final class GoogleAuthService {
    
    static let shared = GoogleAuthService()
    private init() {}
    
    func signIn() async throws -> String {
        guard let rootVC = Self.topViewController() else {
            throw NSError(domain: "GoogleSignIn", code: -1, userInfo: [NSLocalizedDescriptionKey: "No root view controller"])
        }
        return try await signIn(presenting: rootVC)
    }
    
    func signIn(presenting viewController: UIViewController) async throws -> String {
        
        return try await withCheckedThrowingContinuation { continuation in
            GIDSignIn.sharedInstance.signIn(withPresenting: viewController) { response, error in
                if let error = error {
                    continuation.resume(throwing: error)
                    return
                }
                guard let idToken = response?.user.idToken?.tokenString else {
                    continuation.resume(
                        throwing: NSError(
                            domain: "GoogleSignIn",
                            code: -1,
                            userInfo: [NSLocalizedDescriptionKey: "No idToken"]
                        )
                    )
                    return
                }
                continuation.resume(returning: idToken)
            }
        }
    }
    
    static func topViewController(
        _ base: UIViewController? = UIApplication.shared.connectedScenes
            .compactMap { ($0 as? UIWindowScene)?.keyWindow }
            .first?.rootViewController
    ) -> UIViewController? {
        if let nav = base as? UINavigationController {
            return topViewController(nav.visibleViewController)
        }
        if let tab = base as? UITabBarController {
            return topViewController(tab.selectedViewController)
        }
        if let presented = base?.presentedViewController {
            return topViewController(presented)
        }
        return base
    }
    
}
