//
//  SignInResponseDTO.swift
//  Whiplash-iOS
//
//  Created by 남경민 on 7/8/25.
//

import Foundation

struct SignInResponseDTO: Respondable {
    let accessToken: String
    let refreshToken: String
    let nickname: String
    let isNewMember: Bool
    
    init(accessToken: String,
         refreshToken: String,
         nickname: String,
         isNewMember: Bool) {
        self.accessToken = accessToken
        self.refreshToken = refreshToken
        self.nickname = nickname
        self.isNewMember = isNewMember
    }
}

extension SignInResponseDTO {
    
    var toDomain: SignInInfo {
        .init(accessToken: accessToken,
              refreshToken: refreshToken)
    }
    
}
