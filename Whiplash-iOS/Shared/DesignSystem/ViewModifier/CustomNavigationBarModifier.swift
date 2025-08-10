//
//  CustomNavigationBarModifier.swift
//  Whiplash-iOS
//
//  Created by 남경민 on 8/2/25.
//

import Foundation
import SwiftUI

struct CustomNavigationBarModifier<C, L, R> : ViewModifier where C : View, L : View, R : View {
    let centerView: (() -> C)?
    let leftView: (() -> L)?
    let rightView: (() -> R)?
    
    init(centerView: (() -> C)? = nil, leftView: (() -> L)? = nil, rightView: (() -> R)? = nil) {
        self.centerView = centerView
        self.leftView = leftView
        self.rightView = rightView
    }
    func body(content : Content) -> some View {
        VStack {
            ZStack {
                HStack {
                    self.leftView?()
                    Spacer()
                    self.rightView?()
                }
                .frame(height: 46.0)
                .frame(maxWidth: .infinity)
                .padding(.horizontal, 20)
                
                HStack {
                    Spacer()
                    
                    self.centerView?()
                    
                    Spacer()
                }
            }
            .background(Color.gray900)//.ignoresSafeArea(.all, edges: .top)
            
            content
            
            Spacer()
        }
        .background(Color.gray900)
        .navigationBarBackButtonHidden(true)
    }
}
