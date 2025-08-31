//
//  SheetMessage.swift
//  Whiplash-iOS
//
//  Created by 남경민 on 8/9/25.
//

import SwiftUI

struct SheetMessage: View {
    let text: String
    var body: some View {
        Text(text)
            .font(TextStyle.body2_m_14.font)
            .foregroundColor(.gray300)
            .frame(maxWidth: .infinity, alignment: .leading)
    }
}

struct SheetMessage2: View {
    let text: String
    var body: some View {
        Text(text)
            .font(TextStyle.body2_m_14.font)
            .foregroundColor(.gray300)
            .frame(maxWidth: .infinity, alignment: .center)
    }
}

struct SheetMessage3: View {
    let text: String
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(text)
                .font(TextStyle.body2_m_14.font)
                .foregroundColor(.gray300)
                .frame(maxWidth: .infinity, alignment: .center)
        }
        .padding(.horizontal, 10)
        .padding(.vertical, 4)
        .frame(width: 217)
        .background(.gray700)
        
        .cornerRadius(4)
        .overlay(
            RoundedRectangle(cornerRadius: 4)
                .inset(by: 0.5)
                .stroke(.gray600, lineWidth: 1)
            
        )
    }
}
