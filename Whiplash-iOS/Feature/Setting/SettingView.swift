//
//  SettingView.swift
//  Whiplash-iOS
//
//  Created by 남경민 on 8/11/25.
//

import SwiftUI
import ComposableArchitecture

struct SettingView: View {
    @Bindable var store: StoreOf<SettingFeature>
    
    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                // 버전 정보 섹션
                versionSection
                
                // 약관 및 정책 섹션
                termsSection
                
                // 서비스 설정 섹션
                serviceSection
                
                // 로그인/탈퇴 섹션
                loginSection
                
                Spacer(minLength: 100)
            }
            .padding(.horizontal, 20)
        }
        .background(Color.gray900)
        .customNavigationBar(
            leftView: {
                Button {
                    store.send(.backButtonTapped)
                } label: {
                    Image(systemName: "chevron.left")
                        .foregroundColor(.white)
                        .font(.title2)
                }
            },
            centerView: {
                AppText(text: "회원 정보",
                        style: .subtitle5_b_16,
                        color: .gray50)
            }
        )
        .onAppear {
            store.send(.onAppear)
        }
        .alert("업데이트 알림", isPresented: $store.showingUpdateAlert.sending(\.showUpdateAlert)) {
            Button("나중에", role: .cancel) { }
            Button("업데이트") {
                store.send(.updateApp)
            }
        } message: {
            Text("새로운 버전이 있습니다. 업데이트하시겠습니까?")
        }
        // 로그아웃 확인 팝업
        .alert("로그아웃", isPresented: $store.showingLogoutAlert.sending(\.showLogoutAlert)) {
            Button("취소", role: .cancel) { store.send(.cancelLogout) }
            Button("로그아웃", role: .destructive) { store.send(.confirmLogout) }
        } message: {
            Text("정말 로그아웃하시겠습니까?")
        }
        
        // 회원 탈퇴 확인 팝업
        .alert("회원 탈퇴", isPresented: $store.showingsignoutAlert.sending(\.showSignoutAlert)) {
            Button("취소", role: .cancel) { store.send(.cancelsignout) }
            Button("탈퇴", role: .destructive) { store.send(.confirmsignout) }
        } message: {
            Text("회원 탈퇴 시 모든 데이터가 삭제되며 복구할 수 없습니다.\n정말 탈퇴하시겠습니까?")
        }
        .sheet(isPresented: .constant(store.showingMailComposer)) {
            MailComposeView(
                recipient: "hyg100@naver.com",
                subject: "문의사항",
                messageBody: "안녕하세요.\n\n문의사항을 입력해주세요."
            ) {
                store.send(.mailComposerClosed)
            }
        }
        .alert("메일 앱 없음", isPresented: .constant(store.showingMailAlert)) {
            Button("확인") {
                store.send(.showMailAlert(false))
            }
        } message: {
            Text("메일 앱이 설치되어 있지 않습니다.\nhyg100@naver.com으로 직접 문의해주세요.")
        }
    }
    
    // MARK: - 버전 정보 섹션
    
    private var versionSection: some View {
        VStack(spacing: 16) {
            sectionHeader("버전 정보")
            
            settingRow(
                icon: "info.circle",
                title: "현재 버전",
                subtitle: store.currentVersion,
                hasChevron: false
            ) {
                //store.send(.currentVersionTapped)
            }
        }
        .padding(.top, 32)
    }
    
    // MARK: - 약관 및 정책 섹션
    
    private var termsSection: some View {
        VStack(spacing: 16) {
            sectionHeader("약관 및 정책")
            
            VStack(spacing: 0) {
                settingRow(
                    icon: "doc.text",
                    title: "이용약관"
                ) {
                    store.send(.termsOfUseTapped)
                }
                
                settingRow(
                    icon: "hand.raised",
                    title: "개인정보처리방침"
                ) {
                    store.send(.privacyPolicyTapped)
                }
                /*
                 settingRow(
                 icon: "location",
                 title: "정보동의 설정"
                 ) {
                 store.send(.locationInfoAgreementTapped)
                 }*/
            }
        }
        .padding(.top, 40)
    }
    
    // MARK: - 서비스 설정 섹션
    
    private var serviceSection: some View {
        VStack(spacing: 16) {
            sectionHeader("서비스 설정")
            
            settingRow(
                icon: "headphones",
                title: "문의하기"
            ) {
                store.send(.inquiryTapped)
            }
        }
        .padding(.top, 40)
    }
    
    // MARK: - 로그인/탈퇴 섹션
    
    private var loginSection: some View {
        VStack(spacing: 16) {
            sectionHeader("로그인/탈퇴")
            
            VStack(spacing: 0) {
                settingRow(
                    icon: "person.2",
                    title: "로그아웃하기"
                ) {
                    store.send(.showLogoutAlert(true))
                }
                
                settingRow(
                    icon: "video",
                    title: "회원 탈퇴"
                ) {
                    store.send(.showSignoutAlert(true))
                }
            }
        }
        .padding(.top, 40)
    }
    
    // MARK: - 헬퍼 뷰들
    
    private func sectionHeader(_ title: String) -> some View {
        HStack {
            AppText(text: title,
                    style: .body4_m_12,
                    color: .gray500)
            Spacer()
        }
    }
    
    private func settingRow(
        icon: String,
        title: String,
        subtitle: String? = nil,
        hasChevron: Bool = true,
        action: @escaping () -> Void
    ) -> some View {
        Button(action: action) {
            HStack(spacing: 12) {
                // 아이콘
                Image(systemName: icon)
                    .foregroundColor(.white)
                    .font(.system(size: 20))
                    .frame(width: 24, height: 24)
                
                // 제목과 부제목
                VStack(alignment: .leading, spacing: 2) {
                    AppText(text: title,
                            style: .body1_m_16,
                            color: .white)
                    
                    if let subtitle = subtitle {
                        AppText(text: subtitle,
                                style: .body4_m_12,
                                color: .gray500)
                    }
                }
                
                Spacer()
                
                // 화살표 (선택사항)
                if hasChevron {
                    Image(systemName: "chevron.right")
                        .foregroundColor(.gray500)
                        .font(.system(size: 14))
                }
            }
            .padding(.vertical, 16)
            .padding(.horizontal, 4)
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    SettingView(
        store: Store(initialState: SettingFeature.State()) {
            SettingFeature()
        }
    )
}
