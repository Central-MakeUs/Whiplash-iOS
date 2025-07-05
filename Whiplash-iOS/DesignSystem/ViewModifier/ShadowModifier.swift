//
//  ShadowModifier.swift
//  Whiplash-iOS
//
//  Created by 남경민 on 7/6/25.
//

import SwiftUI

struct ShadowModifier: ViewModifier {
    func body(content: Content) -> some View {
        content.shadow(
            color: Color.black.opacity(0.4),
            radius: 8,
            x: 0,
            y: 4
        )
    }
}

extension View {
    func shadow1() -> some View {
        self.modifier(ShadowModifier())
    }
}
