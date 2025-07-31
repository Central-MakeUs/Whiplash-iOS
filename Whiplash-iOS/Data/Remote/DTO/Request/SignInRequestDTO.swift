//
//  SignInRequestDTO.swift
//  Whiplash-iOS
//
//  Created by 남경민 on 7/8/25.
//

import Foundation

public struct SignInRequestDTO: Requestable {
    let socialType: String
    let token: String
    let deviceId: String
    let originalNonce: String?
    
    init(socialType: String,
         token: String,
         deviceId: String,
         originalNonce: String) {
        self.socialType = socialType
        self.token = token
        self.deviceId = deviceId
        self.originalNonce = originalNonce
    }
}
