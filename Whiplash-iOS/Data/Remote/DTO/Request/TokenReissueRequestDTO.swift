//
//  TokenReissueRequestDTO.swift
//  Whiplash-iOS
//
//  Created by 남경민 on 7/8/25.
//

import Foundation

struct TokenReissueRequestDTO: Requestable {
    let refreshToken: String

    init(refreshToken: String) {
        self.refreshToken = refreshToken
    }
}
