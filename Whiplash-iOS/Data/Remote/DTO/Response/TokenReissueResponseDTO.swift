//
//  TokenReissueResponseDTO.swift
//  Whiplash-iOS
//
//  Created by 남경민 on 7/8/25.
//

import Foundation

struct TokenReissueResponseDTO: Decodable {
    let accessToken: String
    let refreshToken: String

    init(accessToken: String,
         refreshToken: String) {
        self.accessToken = accessToken
        self.refreshToken = refreshToken
    }
}
