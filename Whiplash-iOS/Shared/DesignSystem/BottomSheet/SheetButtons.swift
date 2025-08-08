//
//  SheetButtons.swift
//  Whiplash-iOS
//
//  Created by 남경민 on 8/9/25.
//

import SwiftUI

struct SheetButtons: View {
    var leftTitle: String? = nil
    var leftAction: (() -> Void)? = nil
    var rightTitle: String
    var rightEnabled: Bool = true
    var rightStylePrimary: Bool = true
    var rightAction: () -> Void
    var body: some View {
        HStack(spacing: 12) {
            if let leftTitle, let leftAction {
                Button(leftTitle, action: leftAction)
                    .frame(maxWidth: .infinity).padding(.vertical, 14)
                    .frame(height: 48)
                    .background(.gray800)
                    .foregroundStyle(.white)
                    .font(TextStyle.subtitle5_b_16.font)
                    .clipShape(RoundedRectangle(cornerRadius: 4))
            }
            Button(rightTitle, action: rightAction)
                .frame(maxWidth: .infinity).padding(.vertical, 14)
                .frame(height: 48)
                .background(rightStylePrimary ? Color.white : .gray900)
                .foregroundStyle(rightStylePrimary ? .gray800 : .white)
                .font(TextStyle.subtitle5_b_16.font)
                .opacity(rightEnabled ? 1 : 0.5)
                .disabled(!rightEnabled)
                .clipShape(RoundedRectangle(cornerRadius: 4))
                .overlay(
                    RoundedRectangle(cornerRadius: 4)
                        .stroke(.gray700,
                                lineWidth: rightStylePrimary ? 1 : 0)
                )
            
        }
    }
}
