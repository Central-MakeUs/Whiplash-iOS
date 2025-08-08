//
//  SheetTitle.swift
//  Whiplash-iOS
//
//  Created by 남경민 on 8/9/25.
//

import SwiftUI

struct SheetTitle: View {
    let text: String
    var body: some View {
        Text(text)
            .font(TextStyle.subtitle3_b_18.font)
            .foregroundStyle(.white)
            .frame(maxWidth: .infinity, alignment: .leading)
    }
}
