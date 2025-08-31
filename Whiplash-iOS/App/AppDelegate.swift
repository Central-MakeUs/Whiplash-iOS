//
//  AppDelegate.swift
//  Whiplash-iOS
//
//  Created by 남경민 on 8/1/25.
//

import Foundation
import KakaoSDKCommon
import UIKit
import SwiftUI
import UserNotifications
import ComposableArchitecture

class AppDelegate: NSObject, UIApplicationDelegate, UNUserNotificationCenterDelegate {
    weak var rootStore: StoreOf<RootFeature>?
    
    let userNotificationCenter = UNUserNotificationCenter.current()
    
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil
    ) -> Bool {
        guard let kakaoAppKey = Bundle.current.object(forInfoDictionaryKey: "KAKAO_NATIVE_APP_KEY") as? String else {
            fatalError("KAKAO_NATIVE_APP_KEY not found in Info.plist")
        }
        KakaoSDK.initSDK(appKey: kakaoAppKey)
        // 알림 델리게이트 설정
        userNotificationCenter.delegate = self
        
        let authorizationOption: UNAuthorizationOptions = [.alert, .badge, .sound]
        userNotificationCenter.requestAuthorization(options: authorizationOption) { allow, error in
            if let error = error {
                print("error: \(error.localizedDescription)")
            }
            print(allow)
        }
        
        return true
        
    }
    
}

extension AppDelegate {
    
    // 🔥 앱이 포그라운드에 있을 때 알림 수신
    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        willPresent notification: UNNotification,
        withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void
    ) {
        
        let userInfo = notification.request.content.userInfo
        
        print("🔔 포그라운드에서 알림 수신")
        print("   title: \(notification.request.content.title)")
        print("   userInfo: \(userInfo)")
        
        // 알람 ID 추출
        if let alarmIdString = notification.request.content.userInfo["alarmId"] as? String,
           let alarmId = Int(alarmIdString),
            let soundId = notification.request.content.userInfo["soundId"] as? String {
            
            print("포그라운드 알람 감지: ID \(alarmId)")
            
            if #available(iOS 14.0, *) {
                completionHandler([.banner, .list, .badge, .sound])
            } else {
                completionHandler([.badge, .sound])
            }
            
            // 저장된 알람 찾기 및 전체화면 표시
            sendAlarmEvent(alarmId: alarmId, soundId: soundId)
            
        } else {
            // 일반 알림은 기본 처리
            if #available(iOS 14.0, *) {
                completionHandler([.banner, .list, .badge, .sound])
            } else {
                completionHandler([.badge, .sound])
            }
        }
    }
    
    // 사용자가 알림을 탭했을 때
    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        didReceive response: UNNotificationResponse,
        withCompletionHandler completionHandler: @escaping () -> Void
    ) {
        print("알림 응답: \(response.actionIdentifier)")
        print("알림 응답: \(response.notification.request.content.userInfo["alarmId"])")
        print("사운드 아이디 응답: \(response.notification.request.content.userInfo["soundId"])")
        
        if let alarmId = response.notification.request.content.userInfo["alarmId"] as? Int,
           let soundId = response.notification.request.content.userInfo["soundId"] as? String{
            
            print("알림 응답")
            switch response.actionIdentifier {
            case UNNotificationDefaultActionIdentifier:
                // 알림 탭 - 전체화면 알람 표시
                print("알림 탭 - 전체화면 알람 표시")
                sendAlarmEvent(alarmId: alarmId, soundId: soundId)
                
            case "SNOOZE_ACTION":
                // 스누즈 처리
                handleSnoozeAction(alarmId: alarmId)
                
            case "STOP_ACTION":
                // 알람 정지
                handleStopAction(alarmId: alarmId)
                
            default:
                break
            }
        }
        
        completionHandler()
    }
    
    private func sendAlarmEvent(alarmId: Int, soundId: String) {
        print("📡 TCA로 알람 이벤트 전송: \(alarmId)")
        
        Task { @MainActor in
            
            if let store = rootStore {
                print("✅ RootStore 참조 존재 - TCA 액션 전송")
                
                store.send(.alarmNotificationReceived(alarmId, soundId))
                
                print("📤 TCA 액션 전송 완료: alarmNotificationReceived(\(alarmId))")
                
            } else {
                print("⚠️ RootStore 참조가 없음 - 대안 방법 사용")
                
                NotificationCenter.default.post(
                    name: .alarmTriggeredFromDelegate,
                    object: nil,
                    userInfo: ["alarmId": alarmId, "soundId": soundId]
                )
                print("📡 NotificationCenter로 대안 이벤트 전송")
            }
        }
    }
    
    private func handleSnoozeAction(alarmId: Int) {
        print("스누즈 처리: \(alarmId)")
        // 5분 후 재알림 설정
    }
    
    private func handleStopAction(alarmId: Int) {
        print("알람 정지: \(alarmId)")
        // 알람 완전 정지
    }
}

extension Notification.Name {
    static let alarmTriggeredFromDelegate = Notification.Name("alarmTriggeredFromDelegate")
}
