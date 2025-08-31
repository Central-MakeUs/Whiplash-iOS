//
//  AppSearchBar.swift
//  Whiplash-iOS
//
//  Created by 남경민 on 8/3/25.
//

import SwiftUI

struct AppSearchBar: View {
    @Binding var text: String
    var placeholder: String = "검색"
    var onClear: (() -> Void)?
    
    @FocusState private var focused: Bool

    var body: some View {
        HStack {
            if text.isEmpty {
                Image(.Image.icSearchGray22)
            } else {
                Image(.Image.icSearchBlack22)
            }
            
            
            TextField("", text: $text)
                .foregroundColor(.white)
                .focused($focused)
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
            
            if !text.isEmpty {
                Button(action: {
                    text = ""
                    onClear?()
                }) {
                    Image(.Image.icCircleDismiss22)
                }
                .buttonStyle(.plain)
            }
        }
        .padding(.vertical, 10)
        .padding(.horizontal, 12)
        .frame(height: 44)
        .background(
            RoundedRectangle(cornerRadius: 4)
                .fill(.gray900)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 4)
                .stroke(focused ? .lemon400 : .gray600, lineWidth: 1)
        )
    }
}

struct AppSearchBarPreView: View {
    @Binding var text: String
    var placeholder: String = "검색"

    var body: some View {
        HStack {
                
            Image(.Image.icSearchGray22)
        
            HStack {
                if text.isEmpty {
                    AppText(text: placeholder,
                            style: .body1_m_16,
                            color: .gray500)
                } else {
                    AppText(text: text,
                            style: .body1_m_16,
                            color: .white)
                }
                    
                Spacer()
                
            }
        }
        .padding(.vertical, 10)
        .padding(.horizontal, 12)
        .frame(height: 44)
        .background(
            RoundedRectangle(cornerRadius: 4)
                .fill(.gray900)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 4)
                .stroke(.gray600, lineWidth: 1)
        )
    }
}
