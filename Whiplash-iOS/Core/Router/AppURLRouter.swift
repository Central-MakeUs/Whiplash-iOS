//
//  AppURLRouter.swift
//  Whiplash-iOS
//
//  Created by 남경민 on 8/1/25.
//

import Foundation

final class AppURLRouter {
    static func route(_ url: URL) -> Bool {
        
        if KakaoURLHandler.handle(url) { return true }

        return false
    }
}
