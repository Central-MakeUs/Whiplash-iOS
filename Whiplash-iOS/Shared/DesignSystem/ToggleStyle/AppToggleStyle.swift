//
//  BaseToggleStyle.swift
//  Whiplash-iOS
//
//  Created by 남경민 on 8/2/25.
//

import SwiftUI

struct AppToggleStyle: ToggleStyle {
    func makeBody(configuration: Configuration) -> some View {
        HStack {
            configuration.label

            ZStack(alignment: configuration.isOn ? .trailing : .leading) {
                // 트랙
                RoundedRectangle(cornerRadius: 99)
                    .fill(.gray800)
                    .frame(width: 50, height: 28)
                
                if configuration.isOn {
                    RoundedRectangle(cornerRadius: 99)
                        .fill(.lemon10)
                        .frame(width: 50, height: 28)
                }

                // Thumb
                Circle()
                    .fill(configuration.isOn ? .lemon400 : .gray500)
                    .frame(width: 24, height: 24)
                    .padding(.horizontal, 2)
            }
            .animation(.easeInOut(duration: 0.2), value: configuration.isOn)
            .onTapGesture {
                configuration.isOn.toggle()
            }
        }
    }
}
