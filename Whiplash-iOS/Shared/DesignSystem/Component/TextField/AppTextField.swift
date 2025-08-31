//
//  BaseTextField.swift
//  Whiplash-iOS
//
//  Created by 남경민 on 8/2/25.
//

import SwiftUI

struct AppTextField: View {
    @Binding var text: String
    let placeholder: String

    var body: some View {
        HStack(spacing: 8) {
            TextField("", text: $text)
                .foregroundColor(.white)
                .font(TextStyle.body1_m_16.font)
                .padding(.vertical, 10)
                .background(
                    HStack {
                        if text.isEmpty {
                            AppText(text: placeholder,
                                    style: .body1_m_16,
                                    color: .gray500)
                            Spacer()
                        }
                    }
                )
        }
        .padding(.horizontal, 12)
        .frame(height: 44)
        .background(.gray900)
        .cornerRadius(4)
        .overlay(
            RoundedRectangle(cornerRadius: 4)
                .stroke(.gray600, lineWidth: 1)
        )
    }
}
