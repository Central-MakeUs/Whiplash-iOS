//
//  Sheet.swift
//  Whiplash-iOS
//
//  Created by 남경민 on 8/9/25.
//

import SwiftUI

/// 위치 인증 CTA
struct VerifyLocationSheet: View {
    var onConfirm: () -> Void
    var onCancel: () -> Void
    var body: some View {
        VStack(alignment: .center, spacing: 0) {
            Spacer().frame(height: 12)
            SheetTitle2(text: "현재 위치를 인증해주세요")
            Spacer().frame(height: 28)
            SheetButtons(leftTitle: "취소", leftAction: onCancel,
                         rightTitle: "내 위치 인증하기", rightStylePrimary: true, rightAction: onConfirm)
        }
    }
}

/// 확인중 로딩
struct VerifyingSheet: View {
    var body: some View {
        VStack(spacing: 0) {
            Spacer().frame(height: 12)
            ProgressView().tint(.white)
            Spacer().frame(height: 20)
            SheetTitle2(text: "위치 확인중이에요")
            Spacer().frame(height: 8)
            SheetMessage2(text: "잠시만 기다려 주세요")
        }
    }
}

/// 실패(반경 벗어남)
struct CannotTurnOffSheet: View {
    var onRetry: () -> Void
    var onCancel: () -> Void
    var distanceText: String
    var body: some View {
        VStack(alignment: .center, spacing: 0) {
            Spacer().frame(height: 12)
            Image(.Image.icWarning44)
            Spacer().frame(height: 20)
            SheetTitle2(text: "알람을 끌 수 없어요")
            Spacer().frame(height: 4)
            SheetMessage2(text: "반경 \(distanceText) 안으로 더 가까이 가야해요!")
            Spacer().frame(height: 28)
            SheetButtons(leftTitle: "취소",
                         leftAction: onCancel,
                         rightTitle: "다시 인증하기",
                         rightStylePrimary: true,
                         rightAction: onRetry)
        }
    }
}

/// 1회 사용 안내
struct ConfirmInactiveSheet: View {
    var remaining: Int
    var onUse: () -> Void
    var onCancel: () -> Void
    var body: some View {
        VStack(alignment: .center, spacing: 0) {
            Spacer().frame(height: 12)
            Image(.Image.imgNotice44)
            Spacer().frame(height: 20)
            SheetTitle2(text: "알람 비활성화는 주 2회만 가능해요!")
            Spacer().frame(height: 12)
            SheetMessage3(text: "이번주 남은 비활성화 남은 횟수 \(remaining)회")
            Spacer().frame(height: 28)
            SheetButtons(leftTitle: "취소", leftAction: onCancel,
                         rightTitle: "1회 사용하기", rightStylePrimary: true, rightAction: onUse)
        }
    }
}

/// 한도 소진
struct CannotUseInactiveSheet: View {
    var remaining: Int
    var onMoveToRegister: () -> Void
    
    var body: some View {
        VStack(alignment: .center, spacing: 0) {
            Spacer().frame(height: 12)
            Image(.Image.icWarning44)
            Spacer().frame(height: 20)
            SheetTitle2(text: "알람 비활성화 횟수를 모두 사용했어요!")
            Spacer().frame(height: 4)
            SheetMessage2(text: "지정한 장소로 이동해 인증해 보세요!")
            Spacer().frame(height: 12)
            SheetMessage3(text: "이번주 남은 비활성화 남은 횟수 \(remaining)회")
            Spacer().frame(height: 28)
            SheetButtons(rightTitle: "장소 인증하기", rightStylePrimary: true, rightAction: onMoveToRegister)
        }
    }
}

/// 장소 등록(요약)
struct RegisterPlaceSheet: View {
    var title: String
    var message: String
    var onRegister: () -> Void
    var onCancel: () -> Void
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            SheetTitle(text: title)
            SheetMessage(text: message)
            
            Spacer().frame(height: 28)
            
            SheetButtons(leftTitle: "취소",
                         leftAction: onCancel,
                         rightTitle: "목표 장소 등록하기",
                         rightStylePrimary: true,
                         rightAction: onRegister)
        }
    }
}


enum DemoSheetCase: String, CaseIterable, Identifiable, Equatable {
    case ring, confirm, verifying, cannot, oneoff, exhausted, register
    var id: String { rawValue }
}

struct BottomSheetDemoPreview: View {
    @State private var isPresented = true
    @State private var current: DemoSheetCase = .ring
    
    @State private var snapHeight: CGFloat = 232
    
    var body: some View {
        ZStack {
            Color.gray.opacity(0.2).ignoresSafeArea()
            
            VStack(spacing: 12) {
                Picker("Sheet", selection: $current) {
                    ForEach(DemoSheetCase.allCases) { Text($0.rawValue).tag($0) }
                }
                .pickerStyle(.segmented)
                
                Toggle("isPresented", isOn: $isPresented)
                Spacer()
            }
            .padding()
            
            if current == .ring {
                //RingAlarmView()
            } else {
                
                AppBottomSheet(isPresented: $isPresented,
                               snapHeights: $snapHeight) {
                    switch current {
                    case .confirm:
                        VerifyLocationSheet(
                            onConfirm: { print("confirm") },
                            onCancel:  { isPresented = false }
                        )
                    case .verifying:
                        VerifyingSheet()
                    case .cannot:
                        CannotTurnOffSheet(
                            onRetry:  { print("retry") },
                            onCancel: { isPresented = false },
                            distanceText: "200m"
                        )
                    case .oneoff:
                        ConfirmInactiveSheet(
                            remaining: 2,
                            onUse: { print("use once") },
                            onCancel: { isPresented = false }
                        )
                    case .exhausted:
                        CannotUseInactiveSheet(remaining: 2, onMoveToRegister: { print("move to register") })
                    case .register:
                        RegisterPlaceSheet(
                            title: "ddddd",
                            message: "구리시 갈매동",
                            onRegister: { print("register") },
                            onCancel: { isPresented = false }
                        )
                    case .ring:
                        EmptyView()
                    }
                }
            }
        }
        .onAppear {
            updateSnapHeight()
        }
        .onChange(of: current) { oldValue, newValue in
            updateSnapHeight()
        }
    }
    private func updateSnapHeight() {
        snapHeight = calculateSnapHeight(for: current)
        print(snapHeight)
    }
    
    private func calculateSnapHeight(for type: DemoSheetCase) -> CGFloat {
        switch current {
        case .confirm:
            return 232
        case .verifying:
            return 232
        case .cannot:
            return 332
        case .oneoff:
            return 332
        case .exhausted:
            return 332
        case .register:
            return 232
        case .ring:
            return 0
        }
    }
}

#Preview { BottomSheetDemoPreview() }
