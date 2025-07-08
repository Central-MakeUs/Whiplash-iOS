//
//  TextStyle.swift
//  Whiplash-iOS
//
//  Created by 남경민 on 7/5/25.
//

import SwiftUI

enum TextStyle {
    // Pretendard
    case title1_b_40
    case title2_b_32
    case title3_b_28
    case title4_b_24
    case title5_b_22
    
    case subtitle1_b_20
    case subtitle2_m_20
    case subtitle3_b_18
    case subtitle4_m_18
    case subtitle5_b_16
    case subtitle6_b_14
    
    case body1_m_16
    case body2_m_14
    case body3_b_12
    case body4_m_12
    case body5_m_11
    
    // Paperlogy
    case number1_b_28
    case number2_b_64
}

extension TextStyle {
    var font: Font {
        switch self {
            // Pretendard
        case .title1_b_40:
            return .custom("Pretendard-Bold", size: 40)
        case .title2_b_32:
            return .custom("Pretendard-Bold", size: 32)
        case .title3_b_28:
            return .custom("Pretendard-Bold", size: 28)
        case .title4_b_24:
            return .custom("Pretendard-Bold", size: 24)
        case .title5_b_22:
            return .custom("Pretendard-Bold", size: 22)
            
        case .subtitle1_b_20:
            return .custom("Pretendard-Bold", size: 20)
        case .subtitle2_m_20:
            return .custom("Pretendard-Medium", size: 20)
        case .subtitle3_b_18:
            return .custom("Pretendard-Bold", size: 18)
        case .subtitle4_m_18:
            return .custom("Pretendard-Medium", size: 18)
        case .subtitle5_b_16:
            return .custom("Pretendard-Bold", size: 16)
        case .subtitle6_b_14:
            return .custom("Pretendard-Bold", size: 14)
            
        case .body1_m_16:
            return .custom("Pretendard-Medium", size: 16)
        case .body2_m_14:
            return .custom("Pretendard-Medium", size: 14)
        case .body3_b_12:
            return .custom("Pretendard-Bold", size: 12)
        case .body4_m_12:
            return .custom("Pretendard-Medium", size: 12)
        case .body5_m_11:
            return .custom("Pretendard-Medium", size: 11)
            
            // Paperlogy
        case .number1_b_28:
            return .custom("Paperlogy-7Bold", size: 28)
        case .number2_b_64:
            return .custom("Paperlogy-7Bold", size: 64)
        }
    }
    
    var lineHeight: CGFloat {
        switch self {
        case .title1_b_40: return 60
        case .title2_b_32: return 48
        case .title3_b_28: return 42
        case .title4_b_24: return 36
        case .title5_b_22: return 33
        case .subtitle1_b_20, .subtitle2_m_20: return 30
        case .subtitle3_b_18, .subtitle4_m_18: return 27
        case .subtitle5_b_16, .body1_m_16: return 24
        case .subtitle6_b_14, .body2_m_14: return 21
        case .body3_b_12, .body4_m_12: return 18
        case .body5_m_11: return 16.5
        case .number1_b_28: return 42
        case .number2_b_64: return 96
        }
    }
    
    var letterSpacing: CGFloat {
        return 0
    }
}
