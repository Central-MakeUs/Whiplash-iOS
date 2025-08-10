//
//  AuthRepository.swift
//  Whiplash-iOS
//
//  Created by 남경민 on 7/8/25.
//

import Foundation

public protocol AuthRepository {

    var signIn: @Sendable () async throws -> SignInInfo { get }
    var logout: @Sendable () async throws -> Void { get }
    var signout: @Sendable () async throws -> Void { get }
}
