//
//  AlarmRingingView.swift
//  Whiplash-iOS
//
//  Created by 남경민 on 8/9/25.
//

import SwiftUI

struct RingAlarmView: View {
    @State var remainingTime: Int
    var onVerify: () -> Void
    var onOffOnce: () -> Void
    
    var body: some View {
        ZStack {
            VStack {
                Spacer()
                
                ZStack {
                    // 스파클 배경
                    sparkleBackground
                    
                    // 타이머 텍스트
                    AppText(text: formatTime(remainingTime),
                            style: .number2_b_64,
                            color: .white)
                }
                
                Spacer().frame(height: 28)
                
                HStack(spacing: 12) {
                    
                    AppButton(title: "봐주세요🥹",
                              size: .h48,
                              type: .line,
                              state: .normal) {
                        onOffOnce()
                    }
                    
                    AppButton(title: "장소 인증하기",
                              size: .h48,
                              type: .primary,
                              state: .normal) {
                        onVerify()
                    }
                    
                }
                .padding(.bottom, 50) // Safe Area 고려
            }
            .padding(.horizontal, AppLayout.horizontalPadding)
        }
    }
    
    private var sparkleBackground: some View {
        ZStack {
            Image(.Image.imgClockBg)
                .resizable()
                .scaledToFit()
                .frame(maxWidth: .infinity)
        }
    }
    
    private func formatTime(_ seconds: Int) -> String {
        let minutes = seconds / 60
        let remainingSeconds = seconds % 60
        return String(format: "%02d : %02d", minutes, remainingSeconds)
    }
}

#Preview { BottomSheetDemoPreview() }
