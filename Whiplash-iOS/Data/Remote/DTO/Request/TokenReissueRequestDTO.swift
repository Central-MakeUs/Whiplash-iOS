//
//  TokenReissueRequestDTO.swift
//  Whiplash-iOS
//
//  Created by 남경민 on 7/8/25.
//

import Foundation

public struct TokenReissueRequestDTO: Requestable {
    let deviceId: String

    init(deviceId: String) {
        self.deviceId = deviceId
    }
}
