//
//  SuccessView.swift
//  Whiplash-iOS
//
//  Created by 남경민 on 8/15/25.
//

import SwiftUI
import ComposableArchitecture

struct SuccessView: View {
    @Bindable var store: StoreOf<MapFeature>
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // 기본 배경색
                Color.gray900.ignoresSafeArea()
                
                // 배경 이미지가 전체 화면을 덮도록
                Image(.Image.imgAlarmBg)
                    .resizable()
                    .scaledToFill()
                    .frame(
                        width: geometry.size.width,
                        height: geometry.size.height
                    )
                    .clipped()
                    .ignoresSafeArea()
                    .allowsHitTesting(false)
                
                // 전체 컨텐츠 레이아웃
                VStack(spacing: 0) {
                    // 상단 네비게이션 (Safe Area 고려)
                    //topNavigation
                    
                    // 메인 콘텐츠 영역
                    mainContent
                }
                .ignoresSafeArea(edges: .top) // 상단 Safe Area 무시해서 네비게이션이 상단에 붙도록
            }
        }
    }
    
    private var topNavigation: some View {
        VStack(spacing: 0) {
            // Safe Area 상단 여백
            Rectangle()
                .fill(Color.gray900)
                .frame(height: 0)
                .ignoresSafeArea(edges: .top)
            
            // 네비게이션 바
            HStack {
                Spacer()
                AppText(text: "도착 인증",
                        style: .subtitle5_b_16,
                        color: .gray50)
                Spacer()
            }
            .frame(maxWidth: .infinity)
            .frame(height: 54)
            .background(Color.gray900)
            .padding(.top, 44) // 상태 바 높이만큼 패딩
        }
    }
    
    private var mainContent: some View {
        VStack {
            Spacer()
            
            // 중앙 콘텐츠
            VStack(spacing: 16) {
                Image(.Image.imgSpark40)
                
                VStack(alignment: .center, spacing: 8) {
                    AppText(
                        text: "도착 인증에 성공했어요!",
                        style: .title5_b_22,
                        color: .white
                    )
                    HStack(spacing: 6) {
                        Image(.Image.icMapPinFillGray22)
                        AppText(
                            text: store.mapStyle.place.address,
                            style: .body1_m_16,
                            color: .gray300
                        )
                    }
                }
            }
            .multilineTextAlignment(.center)
            .padding(.horizontal, 20)
            
            Spacer()
            
            // 하단 버튼
            AppButton(
                title: "확인",
                size: .h48,
                type: .black,
                state: .normal
            ) {
                store.send(.successTapped)
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 50)
        }
    }
}
