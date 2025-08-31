//
//  SingInInfo.swift
//  Whiplash-iOS
//
//  Created by 남경민 on 7/8/25.
//

import Foundation

public struct SignInInfo: Equatable {
    public let accessToken: String
    public let refreshToken: String
    
    public init(accessToken: String,
                refreshToken: String) {
        self.accessToken = accessToken
        self.refreshToken = refreshToken
    }
}
