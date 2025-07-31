//
//  KakaoURLHandler.swift
//  Whiplash-iOS
//
//  Created by 남경민 on 8/1/25.
//

import KakaoSDKAuth

final class KakaoURLHandler {
    static func handle(_ url: URL) -> Bool {
        if AuthApi.isKakaoTalkLoginUrl(url) {
            return AuthController.handleOpenUrl(url: url)
        }
        return false
    }
}
