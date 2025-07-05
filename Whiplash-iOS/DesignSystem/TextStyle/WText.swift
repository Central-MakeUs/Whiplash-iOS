//
//  WText.swift
//  Whiplash-iOS
//
//  Created by 남경민 on 7/6/25.
//

import SwiftUI

struct WText: View {
    var text: String
    var style: TextStyle
    var color: Color = .primary
    
    var body: some View {
        Text(text)
            .font(style.font)
            .lineSpacing(style.lineHeight - style.fontSize)
            .kerning(style.letterSpacing)
            .foregroundColor(color)
    }
}

private extension TextStyle {
    var fontSize: CGFloat {
        switch self {
        case .title1_b_40: return 40
        case .title2_b_32: return 32
        case .title3_b_28: return 28
        case .title4_b_24: return 24
        case .title5_b_22: return 22
        case .subtitle1_b_20, .subtitle2_m_20: return 20
        case .subtitle3_b_18, .subtitle4_m_18: return 18
        case .subtitle5_b_16, .body1_m_16: return 16
        case .subtitle6_b_14, .body2_m_14: return 14
        case .body3_b_12, .body4_m_12: return 12
        case .body5_m_11: return 11
        case .number1_b_28: return 28
        case .number2_b_64: return 64
        }
    }
}
