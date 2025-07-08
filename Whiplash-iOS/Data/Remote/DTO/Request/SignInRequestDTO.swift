//
//  SignInRequestDTO.swift
//  Whiplash-iOS
//
//  Created by 남경민 on 7/8/25.
//

import Foundation

struct SignInRequestDTO: Encodable {
    let identityToken: String
    
    init(identityToken: String) {
        self.identityToken = identityToken
    }
}
