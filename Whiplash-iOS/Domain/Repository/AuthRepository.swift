//
//  AuthRepository.swift
//  Whiplash-iOS
//
//  Created by 남경민 on 7/8/25.
//

import Foundation

public protocol AuthRepository {
    var signIn: @Sendable ( _ socialType: SocialLoginType) async throws -> SignInInfo { get }
    var logout: @Sendable ( _ socialType: SocialLoginType) async throws -> Void { get }
}
