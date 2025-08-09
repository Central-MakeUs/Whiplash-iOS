//
//  TokenStore.swift
//  Whiplash-iOS
//
//  Created by 남경민 on 8/9/25.
//

import Foundation

enum TokenKey {
    case accessToken
    case refreshToken
}

protocol TokenStoring {
    func accessToken() -> String?
    func refreshToken() -> String?
    func save(accessToken: String, refreshToken: String)
    func clear()
}

struct TokenStore: TokenStoring {
    func accessToken() -> String? { KeychainProvider.shared.read(.accessToken) }
    func refreshToken() -> String? { KeychainProvider.shared.read(.refreshToken) }
    func save(accessToken: String, refreshToken: String) {
        KeychainProvider.shared.save(accessToken.replacingOccurrences(of: "Bearer ", with: ""), key: .accessToken)
        KeychainProvider.shared.save(refreshToken.replacingOccurrences(of: "Bearer ", with: ""), key: .refreshToken)
    }
    func clear() {
        KeychainProvider.shared.delete(.accessToken)
        KeychainProvider.shared.delete(.refreshToken)
    }
}
