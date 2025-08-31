//
//  OnboardingView.swift
//  Whiplash-iOS
//
//  Created by 남경민 on 8/9/25.
//

import SwiftUI
import ComposableArchitecture

struct OnboardingView: View {
    @Bindable var store: StoreOf<OnboardingFeature>
    
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                if store.currentPage > 0 {
                    Button(action: { store.send(.backTapped) }) {
                        Image(.Image.icLeftArrowBlack28)
                    }
                    .padding(18)
                }
                Spacer()
            }
            .frame(height: 28)
            
            Spacer().frame(height: 100)
            
            HStack(spacing: 8) {
                ForEach(0..<store.totalPages, id: \.self) { i in
                    Circle()
                        .fill(i == store.currentPage ? .white : .gray700)
                        .frame(width: 6, height: 6)
                }
            }
            .padding(.vertical, 12)
            
            Spacer().frame(height: 16)
            
            // 페이지 뷰
            TabView(selection: $store.currentPage.sending(\.pageChanged)) {
                page(image: "Image/img_ob1",
                     title: "무조건 가야 한다!\n목표 장소에 도착해야만 꺼지는 알람!",
                     titleHighlight: ["도착해야만"])
                .tag(0)
                
                page(image: "Image/img_ob2",
                     title: "목표 장소, 목표 시간을\n설정하고",
                     titleHighlight: ["장소","시간"])
                .tag(1)
                
                page(image: "Image/img_ob3",
                     title: "시간 내 도착하지 못하면\n꺼지지 않는 알람이!",
                     titleHighlight: ["꺼지지 않는 알람이!"])
                .tag(2)
                
                page(image: "Image/img_ob4",
                     title: "눈떠와 함께\n당신의 목표를 이뤄보세요!",
                     titleHighlight: ["눈떠"])
                .tag(3)
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
            .onAppear { store.send(.onAppear) }
            
            HStack(spacing: 8) {
                AppButton(title: "건너뛰기",
                          size: .h48,
                          type: .black,
                          state: .normal,
                          action: {
                    store.send(.skipTapped)
                })
                .frame(width: 98)
                AppButton(title: store.currentPage == store.totalPages - 1 ? "시작하기" : "다음",
                          size: .h48,
                          type: .line,
                          state: .normal,
                          action: {
                    store.send(.nextTapped)
                })
                
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 24)
        }
        .background(Color.black.ignoresSafeArea())
        .foregroundStyle(.white)
    }
    
    private func page(image: String,
                      title: String,
                      titleHighlight: [String]) -> some View {
        VStack(spacing: 38) {
            
            Text(makeOnboardingText(title, highlights: titleHighlight))
                .multilineTextAlignment(.center)
                .lineSpacing(2)
                .frame(maxWidth: .infinity)

            
            Image(image)
                .resizable()
                .scaledToFit()
            
            
            Spacer()
        }
        .padding(.horizontal, 20)
    }
    
    func makeOnboardingText(_ full: String, highlights: [String]) -> AttributedString {
        var a = AttributedString(full)
        a.font = .custom("Pretendard", size: 18).weight(.bold)
        a.foregroundColor = .white

        for word in highlights {
            if let range = a.range(of: word) {
                a[range].foregroundColor = .lemon400
            }
        }
        return a
    }

}

#Preview {
    OnboardingView(
        store: Store(initialState: OnboardingFeature.State()) {
            OnboardingFeature()
        }
    )
}
