//
//  BaseButton.swift
//  Whiplash-iOS
//
//  Created by 남경민 on 7/6/25.
//

import SwiftUI

struct BaseButton: View {
    let title: String
    let size: ButtonSize
    let type: ButtonType
    let state: ButtonState
    let action: () -> Void
    
    var body: some View {
        let style = ButtonDesign.style(size: size,
                                       type: type,
                                       state: state)
        
        Button(action: {
            if state != .disabled { action() }
        }) {
            BaseText(text: title,
                     style: .subtitle5_b_16,
                     color: style.foregroundColor)
                .frame(maxWidth: .infinity)
                .frame(height: style.height)
                .background(style.backgroundColor)
                .overlay(
                    RoundedRectangle(cornerRadius: 4)
                        .stroke(style.borderColor ?? .clear,
                                lineWidth: style.borderColor != nil ? 1 : 0)
                )
                .cornerRadius(4)
        }
        .disabled(state == .disabled)
    }
}

enum ButtonSize {
    case h48, h44
}

enum ButtonType {
    case primary, black, line
}

enum ButtonState {
    case normal, pressed, disabled
}

struct ButtonStyle {
    var backgroundColor: Color
    var foregroundColor: Color
    var borderColor: Color?
    var height: CGFloat
}

struct ButtonDesign {
    static func style(
        size: ButtonSize,
        type: ButtonType,
        state: ButtonState
    ) -> ButtonStyle {
        let height: CGFloat = size == .h48 ? 48 : 44
        
        switch (type, state) {
        case (.primary, .normal):
            return ButtonStyle(backgroundColor: Color.lemon400,
                               foregroundColor: Color.gray900,
                               borderColor: nil,
                               height: height)
        case (.primary, .pressed):
            return ButtonStyle(backgroundColor:
                                Color.lemon500,
                               foregroundColor: Color.gray900,
                               borderColor: nil,
                               height: height)
        case (.primary, .disabled):
            return ButtonStyle(backgroundColor: Color.lemon400.opacity(0.3),
                               foregroundColor: Color.gray900.opacity(0.9),
                               borderColor: nil,
                               height: height)
            
        case (.black, .normal):
            return ButtonStyle(backgroundColor: Color.gray800,
                               foregroundColor: Color.white,
                               borderColor: Color.gray700,
                               height: height)
            
        case (.black, .pressed):
            return ButtonStyle(backgroundColor: Color.gray900,
                               foregroundColor: Color.white,
                               borderColor: Color.gray700,
                               height: height)
        case (.black, .disabled):
            return ButtonStyle(backgroundColor: Color.gray800,
                               foregroundColor: Color.white.opacity(0.5),
                               borderColor: Color.gray700.opacity(0.9),
                               height: height)
            
        case (.line, .normal):
            return ButtonStyle(backgroundColor: Color.white,
                               foregroundColor: Color.gray900,
                               borderColor: nil,
                               height: height)
        case (.line, .pressed):
            return ButtonStyle(backgroundColor: Color.gray100,
                               foregroundColor: Color.gray900,
                               borderColor: nil,
                               height: height)
        case (.line, .disabled):
            return ButtonStyle(backgroundColor: Color.gray50.opacity(0.2),
                               foregroundColor: Color.gray900,
                               borderColor: nil,
                               height: height)
        }
    }
}
