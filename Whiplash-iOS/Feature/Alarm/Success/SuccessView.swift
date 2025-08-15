//
//  SuccessView.swift
//  Whiplash-iOS
//
//  Created by 남경민 on 8/15/25.
//

import SwiftUI
import ComposableArchitecture

struct SuccessView: View {
    var locationName: String = "위치명"
    
    var body: some View {
        ZStack {
            // 기본 배경색
            Color.gray900.ignoresSafeArea()
            
            // 배경 이미지가 전체 화면을 덮도록
            Image(.Image.imgAlarmBg)
                .resizable()
                .scaledToFill()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .clipped() // 넘치는 부분 잘라내기
                .ignoresSafeArea()
                .allowsHitTesting(false)
            
            // 전체 컨텐츠 레이아웃
            VStack(spacing: 0) {
                // 상단 네비게이션
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
                .safeAreaInset(edge: .top) {
                    Color.gray900.frame(height: 0)
                }
                
                // 메인 콘텐츠 영역
                VStack {
                    Spacer()
                    
                    // 중앙 콘텐츠
                    VStack(spacing: 16) {
                        Image(.Image.imgSpark40)
                        
                        VStack(spacing: 8) {
                            AppText(
                                text: "도착 인증에 성공했어요!",
                                style: .title5_b_22,
                                color: .white
                            )
                            HStack(spacing: 6) {
                                Image(.Image.icMapPinFillGray22)
                                AppText(
                                    text: locationName,
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
                        // store.send(.confirmTapped)
                    }
                    .padding(.horizontal, AppLayout.horizontalPadding)
                    .padding(.bottom, 50) // 하단 여백
                    
                    Spacer().frame(height: 34)
                }
            }
            .padding(.top, 44)
        }
    }
}

#Preview {
    SuccessView()
}
