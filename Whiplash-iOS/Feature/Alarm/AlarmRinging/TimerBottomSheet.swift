//
//  TimerBottomSheet.swift
//  Whiplash-iOS
//
//  Created by 남경민 on 8/15/25.
//

import SwiftUI
import ComposableArchitecture

// MARK: - 타이머 바텀 시트 뷰
struct TimerBottomSheet: View {
    let timeRemaining: Int
    let isRunning: Bool
    let onSkip: () -> Void
    let onVerify: () -> Void
    
    @State private var dragOffset: CGFloat = 0
    @State private var isDragging: Bool = false
    
    var body: some View {
        VStack(spacing: 0) {
            // 타이머 영역 (지도 위에 오버레이)
            timerOverlay
            
            // 바텀 시트
            bottomSheetContent
                .background(Color.gray900)
                .clipShape(
                    .rect(
                        topLeadingRadius: 20,
                        topTrailingRadius: 20
                    )
                )
        }
    }
    
    private var timerOverlay: some View {
        VStack {
            Spacer()
            
            // 타이머 표시 (지도 위 오버레이)
            ZStack {
                // 배경 장식 (스파클 효과)
                sparkleBackground
                
                // 메인 타이머
                Text(formatTime(timeRemaining))
                    .font(.system(size: 48, weight: .bold, design: .monospaced))
                    .foregroundColor(.white)
                    .shadow(color: .black.opacity(0.3), radius: 2, x: 0, y: 2)
            }
            .padding(.horizontal, 40)
            .padding(.vertical, 20)
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color.black.opacity(0.6))
                    .blur(radius: 0.5)
            )
            .padding(.bottom, 20)
        }
    }
    
    private var sparkleBackground: some View {
        ZStack {
            // 왼쪽 위 스파클
            sparkleIcon
                .offset(x: -60, y: -30)
                .opacity(0.7)
            
            // 오른쪽 아래 스파클
            sparkleIcon
                .offset(x: 70, y: 40)
                .opacity(0.5)
            
            // 왼쪽 아래 스파클
            sparkleIcon
                .offset(x: -80, y: 50)
                .opacity(0.4)
                .scaleEffect(0.8)
        }
    }
    
    private var sparkleIcon: some View {
        Image(systemName: "sparkles")
            .font(.system(size: 24))
            .foregroundColor(.yellow)
    }
    
    private var bottomSheetContent: some View {
        VStack(spacing: 0) {
            // 드래그 핸들
            dragHandle
            
            // 버튼 영역
            buttonArea
        }
    }
    
    private var dragHandle: some View {
        RoundedRectangle(cornerRadius: 2.5)
            .fill(Color.gray600)
            .frame(width: 40, height: 5)
            .padding(.top, 12)
            .padding(.bottom, 24)
    }
    
    private var buttonArea: some View {
        HStack(spacing: 12) {
            // 빠주세요 버튼
            Button(action: onSkip) {
                HStack(spacing: 6) {
                    Text("빠주세요")
                        .font(.system(size: 16, weight: .medium))
                    Text("😢")
                        .font(.system(size: 16))
                }
                .foregroundColor(.gray400)
                .frame(maxWidth: .infinity)
                .frame(height: 52)
                .background(Color.gray800)
                .cornerRadius(12)
            }
            
            // 잠소 인증하기 버튼
            Button(action: onVerify) {
                Text("잠소 인증하기")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.black)
                    .frame(maxWidth: .infinity)
                    .frame(height: 52)
                    .background(Color.green)
                    .cornerRadius(12)
            }
        }
        .padding(.horizontal, 20)
        .padding(.bottom, 34) // Safe Area 고려
    }
    
    private func formatTime(_ seconds: Int) -> String {
        let minutes = seconds / 60
        let remainingSeconds = seconds % 60
        return String(format: "%02d:%02d", minutes, remainingSeconds)
    }
}

