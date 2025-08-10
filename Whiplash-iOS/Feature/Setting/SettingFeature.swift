//
//  SettingFeature.swift
//  Whiplash-iOS
//
//  Created by 남경민 on 8/11/25.
//

import SwiftUI
import UIKit
import ComposableArchitecture
import MessageUI

@Reducer
public struct SettingFeature {
    public init() {}
    
    @ObservableState
    public struct State: Equatable {
        public init() {}
        
        // 버전 정보
        var currentVersion: String = "최신버전"
        
        // 사용자 정보
        var userName: String = ""
        var isLoggedIn: Bool = false
        
        // 설정 상태
        var showingUpdateAlert: Bool = false
        var showingLogoutAlert: Bool = false
        var showingsignoutAlert: Bool = false
        var isLoading: Bool = false
        
        // 메일 관련
        var showingMailComposer: Bool = false
        var showingMailAlert: Bool = false
    }
    
    public enum Action {
        case onAppear
        case backButtonTapped
        
        // 버전 정보
        case currentVersionTapped
        
        // 약관 및 정책
        case termsOfUseTapped
        case privacyPolicyTapped
        case locationInfoAgreementTapped
        
        // 서비스 설정
        case inquiryTapped
        
        // 로그인/탈퇴
        case logoutTapped
        case signoutTapped
        
        case logoutSuccess
        case logoutFailure(Error)
        
        case signoutSuccess
        case signoutFailure(Error)
        
        
        // 팝업 응답
        case confirmLogout
        case confirmsignout
        case cancelLogout
        case cancelsignout
        
        // 업데이트 관련
        case showUpdateAlert(Bool)
        case updateApp
        
        // 메일 관련
        case showMailComposer(Bool)
        case mailComposerClosed
        case showMailAlert(Bool)
        
        case showLogoutAlert(Bool)
        case showSignoutAlert(Bool)
        
        case delegate(Delegate)
        
        public enum Delegate: Equatable {
            case backButtonTapped
            case termsOfUseRequested
            case privacyPolicyRequested
            case locationInfoRequested
            case inquiryRequested
            case logout
            case signout
        }
    }
    
    @Dependency(\.appleRepository) var authClient
    
    public var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .onAppear:
                // 버전 정보 확인
                state.currentVersion = getCurrentAppVersion()
                return .none
                
            case .backButtonTapped:
                return .send(.delegate(.backButtonTapped))
                
            case .currentVersionTapped:
                // 업데이트 확인
                return checkForUpdate(state: &state)
                
            case .termsOfUseTapped:
                // 사파리로 이용약관 페이지 열기
                return openWebPage(urlString: "https://nonstop-alibi-f82.notion.site/2431862b9eb28060b16ec47a60fcef22")
                
            case .privacyPolicyTapped:
                // 사파리로 개인정보 처리방침 페이지 열기
                return openWebPage(urlString: "https://nonstop-alibi-f82.notion.site/2431862b9eb2800b95cdcf5daea2e83e")
                
            case .locationInfoAgreementTapped:
                // 사파리로 위치정보 동의 페이지 열기
                return openWebPage(urlString: "https://your-app.com/location-agreement")
                
            case .inquiryTapped:
                // 메일 앱으로 문의하기
                return openMailComposer(state: &state)
                
            case .logoutTapped:
                Logger.shared.log(level: .debug, category: .etc, "로그아웃")
                
                return .run { send in
                    do {
                        try await authClient.logout()
                        // 성공 시
                        await send(.logoutSuccess)
                    } catch {
                        // 실패 시
                        await send(.logoutFailure(error))
                    }
                }
            case .logoutSuccess:
                TokenStore.shared.clear()
                return .send(.delegate(.logout))
                
            case let .logoutFailure(error):
                return .none
                
            case .signoutTapped:
                Logger.shared.log(level: .debug, category: .etc, "회원 탈퇴")
                
                return .run { send in
                    do {
                        try await authClient.signout()
                        // 성공 시
                        await send(.signoutSuccess)
                    } catch {
                        // 실패 시
                        await send(.signoutFailure(error))
                    }
                }
            case .signoutSuccess:
                Logger.shared.log(level: .debug, category: .etc, "회원 탈퇴 성공 호출됨")
                TokenStore.shared.clear()
                return .send(.delegate(.signout))
                
            case let .signoutFailure(error):
                return .none
                
            case let .showUpdateAlert(show):
                state.showingUpdateAlert = show
                return .none
                
            case .updateApp:
                state.showingUpdateAlert = false
                return openAppStore()
                
            case let .showMailComposer(show):
                state.showingMailComposer = show
                return .none
                
            case .mailComposerClosed:
                state.showingMailComposer = false
                return .none
                
            case let .showMailAlert(show):
                state.showingMailAlert = show
                return .none
                
            case .delegate:
                return .none
            case .confirmLogout:
                return .send(.logoutSuccess)
            case .confirmsignout:
                return .send(.signoutTapped)
            case .cancelLogout:
                state.showingLogoutAlert = false
                return .none
            case .cancelsignout:
                state.showingsignoutAlert = false
                return .none
                
            case let .showLogoutAlert(show):
                state.showingLogoutAlert = show
                return .none
                
            case let .showSignoutAlert(show):
                state.showingsignoutAlert = show
                return .none
            }
        }
    }
    
    // MARK: - Helper Functions
    
    private func getCurrentAppVersion() -> String {
        guard let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String else {
            return "1.0.0"
        }
        return version
    }
    
    private func checkForUpdate(state: inout State) -> Effect<Action> {
        // 업데이트 확인 로직
        return .run { send in
            // 실제로는 App Store API나 서버 API로 최신 버전 확인
            try await Task.sleep(nanoseconds: 1_000_000_000) // 1초 지연
            
            // 임시로 업데이트 있음으로 가정
            let hasUpdate = Bool.random()
            
            if hasUpdate {
                await send(.showUpdateAlert(true))
            }
        }
    }
    
    private func openAppStore() -> Effect<Action> {
        return .run { _ in
            // App Store 열기
            if let url = URL(string: "https://apps.apple.com/app/id여기에앱ID") {
                await UIApplication.shared.open(url)
            }
        }
    }
    
    // 사파리로 웹페이지 열기
    private func openWebPage(urlString: String) -> Effect<Action> {
        return .run { _ in
            guard let url = URL(string: urlString) else { return }
            await UIApplication.shared.open(url)
        }
    }
    
    // 메일 앱으로 문의하기
    private func openMailComposer(state: inout State) -> Effect<Action> {
        return .run { send in
            // 메일 앱 사용 가능 여부 확인
            if MFMailComposeViewController.canSendMail() {
                await send(.showMailComposer(true))
            } else {
                // 메일 앱을 사용할 수 없는 경우 직접 메일 앱 열기
                let email = "hyg100@naver.com"
                let subject = "문의사항"
                let body = "안녕하세요.\n\n문의사항을 입력해주세요."
                
                let encodedSubject = subject.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
                let encodedBody = body.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
                
                if let url = URL(string: "mailto:\(email)?subject=\(encodedSubject)&body=\(encodedBody)") {
                    if await UIApplication.shared.canOpenURL(url) {
                        await UIApplication.shared.open(url)
                    } else {
                        // 메일 앱이 설치되어 있지 않은 경우
                        await send(.showMailAlert(true))
                    }
                }
            }
        }
    }
}
