//
//  AppBottomSheet.swift
//  Whiplash-iOS
//
//  Created by 남경민 on 8/9/25.
//

import SwiftUI

struct AppBottomSheet<Content: View>: View {
    @Binding var isPresented: Bool
    @Binding var snapHeights: CGFloat
    var allowSwipeToDismiss: Bool = true
    
    private let contentBuilder: () -> Content
    init(
        isPresented: Binding<Bool>,
        snapHeights: Binding<CGFloat>,
        allowSwipeToDismiss: Bool = true,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self._isPresented = isPresented
        self._snapHeights = snapHeights
        self.allowSwipeToDismiss = allowSwipeToDismiss
        self.contentBuilder = content
    }
    
    @State private var currentHeight: CGFloat = 0
    @State private var translation: CGFloat = 0
    
    var body: some View {
        ZStack {
            VStack {
                Spacer()
                
                VStack(spacing: 0) {
                    Capsule()
                        .frame(width: 36, height: 4)
                        .foregroundColor(.white.opacity(0.3))
                        .padding(.top, 8)
                        .padding(.bottom, 12)
                    
                    // Content
                    contentBuilder()
                        .padding(.horizontal, 20)
                        .padding(.top, 12)
                        .padding(.bottom, 16)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    Spacer()
                }
                .frame(maxWidth: .infinity)
                .frame(height: snapHeights)
                .background(
                    UnevenRoundedRectangle(
                        topLeadingRadius: 16,
                        bottomLeadingRadius: 0,
                        bottomTrailingRadius: 0,
                        topTrailingRadius: 16,
                        style: .continuous
                    )
                    .fill(.gray900)
                )
                .offset(y: max(0, translation))
                .transition(.move(edge: .bottom).combined(with: .opacity))
                .gesture(
                    allowSwipeToDismiss
                    ? DragGesture()
                        .onChanged { value in
                            translation = max(0, value.translation.height)
                        }
                        .onEnded { value in
                            withAnimation(.spring(response: 0.28, dampingFraction: 0.86)) {
                                if value.translation.height > 140 {
                                    isPresented = false
                                } else {
                                    let end = snapHeights + value.translation.height
                                    let nearest = snapHeights
                                    currentHeight = nearest
                                }
                                translation = 0
                            }
                        }
                    : nil
                )
            }
            .ignoresSafeArea(edges: .bottom)
        }
        .animation(.spring(response: 0.28, dampingFraction: 0.86), value: isPresented)
    }
}

#Preview { BottomSheetDemoPreview() }
