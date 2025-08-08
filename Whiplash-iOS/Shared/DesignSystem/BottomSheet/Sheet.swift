//
//  Sheet.swift
//  Whiplash-iOS
//
//  Created by 남경민 on 8/9/25.
//

import SwiftUI

/// 위치 인증 CTA
struct ConfirmLocationSheet: View {
    var onConfirm: () -> Void
    var onCancel: () -> Void
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            SheetTitle(text: "현재 위치에서 끄기")
            SheetMessage(text: "설정한 반경 안에 있으면 알람을 끌 수 있어요.")
            SheetButtons(leftTitle: "취소", leftAction: onCancel,
                         rightTitle: "내 위치 인증하기", rightStylePrimary: true, rightAction: onConfirm)
        }
    }
}

/// 확인중 로딩
struct VerifyingSheet: View {
    var body: some View {
        VStack(spacing: 16) {
            ProgressView().tint(.white)
            Text("위치 확인중이에요").foregroundColor(.white)
            Text("잠시만 기다려 주세요").foregroundColor(.gray)
        }
    }
}

/// 실패(반경 벗어남)
struct CannotTurnOffSheet: View {
    var onRetry: () -> Void
    var onCancel: () -> Void
    var distanceText: String
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            SheetTitle(text: "알람을 끌 수 없어요")
            SheetMessage(text: "반경 \(distanceText) 안으로 더 가까이 가야해요!")
            SheetButtons(leftTitle: "취소", leftAction: onCancel,
                         rightTitle: "다시 인증하기", rightStylePrimary: false, rightAction: onRetry)
        }
    }
}

/// 1회 사용 안내
struct UseOneOffSheet: View {
    var remaining: Int
    var onUse: () -> Void
    var onCancel: () -> Void
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            SheetTitle(text: "알람 비활성화는 주 2회만 가능해요!")
            SheetMessage(text: "이번주 남은 비활성화 남은 횟수 \(remaining)회")
            SheetButtons(leftTitle: "취소", leftAction: onCancel,
                         rightTitle: "1회 사용하기", rightStylePrimary: true, rightAction: onUse)
        }
    }
}

/// 한도 소진
struct QuotaExhaustedSheet: View {
    var onMoveToRegister: () -> Void
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            SheetTitle(text: "알람 비활성화 횟수를 모두 사용했어요!")
            SheetMessage(text: "지정한 장소로 이동해 인증해 보세요!")
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
            
            SheetButtons(leftTitle: "취소", leftAction: onCancel,
                         rightTitle: "목표 장소 등록하기", rightStylePrimary: true, rightAction: onRegister)
        }
    }
}


enum DemoSheetCase: String, CaseIterable, Identifiable {
    case confirm, verifying, cannot, oneoff, exhausted, register
    var id: String { rawValue }
}

struct BottomSheetDemoPreview: View {
    @State private var isPresented = true
    @State private var current: DemoSheetCase = .confirm
    
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
            
            AppBottomSheet(isPresented: $isPresented) {
                switch current {
                case .confirm:
                    ConfirmLocationSheet(
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
                    UseOneOffSheet(
                        remaining: 2,
                        onUse: { print("use once") },
                        onCancel: { isPresented = false }
                    )
                case .exhausted:
                    QuotaExhaustedSheet(onMoveToRegister: { print("move to register") })
                case .register:
                    RegisterPlaceSheet(
                        title: "ddddd",
                        message: "구리시 갈매동",
                        onRegister: { print("register") },
                        onCancel: { isPresented = false }
                    )
                }
            }
        }
    }
}

#Preview { BottomSheetDemoPreview() }
