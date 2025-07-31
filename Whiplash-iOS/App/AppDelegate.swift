//
//  AppDelegate.swift
//  Whiplash-iOS
//
//  Created by 남경민 on 8/1/25.
//

import Foundation
import KakaoSDKCommon
import UIKit

class AppDelegate: NSObject, UIApplicationDelegate, UNUserNotificationCenterDelegate {
    
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil
    ) -> Bool {
        guard let kakaoAppKey = Bundle.current.object(forInfoDictionaryKey: "KAKAO_NATIVE_APP_KEY") as? String else {
            fatalError("KAKAO_NATIVE_APP_KEY not found in Info.plist")
        }
        KakaoSDK.initSDK(appKey: kakaoAppKey)
        return true
        
    }
    
}
