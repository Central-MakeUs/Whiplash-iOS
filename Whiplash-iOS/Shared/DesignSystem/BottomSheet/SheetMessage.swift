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
