//
//  View+.swift
//  Whiplash-iOS
//
//  Created by 남경민 on 8/2/25.
//

import SwiftUI

extension View {
    
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
    
    func customNavigationBar<L>(
        leftView: @escaping (()-> L)
    ) -> some View where L : View {
        modifier(
            CustomNavigationBarModifier(
                centerView: { EmptyView() },
                leftView: leftView,
                rightView: { EmptyView() }
            )
        )
    }
    func customNavigationBar<R>(
        rightView: @escaping (()-> R)
    ) -> some View where R : View {
        modifier(
            CustomNavigationBarModifier(
                centerView: { EmptyView() },
                leftView: { EmptyView()} ,
                rightView: rightView
            )
        )
    }
    
    func customNavigationBar<R>(
        centerView: @escaping (()-> R)
    ) -> some View where R : View {
        modifier(
            CustomNavigationBarModifier(
                centerView: centerView,
                leftView: { EmptyView()} ,
                rightView: { EmptyView()}
            )
        )
    }
    
    func customNavigationBar<L,R>(
        leftView: @escaping (()-> L),
        rightView: @escaping (()-> R)
    ) -> some View where L : View, R: View {
        modifier(
            CustomNavigationBarModifier(
                centerView: { EmptyView() },
                leftView: leftView,
                rightView: rightView
            )
        )
    }
    func customNavigationBar<C,R>(
        centerView: @escaping (()-> C),
        rightView: @escaping (()-> R)
    ) -> some View where C : View, R: View {
        modifier(
            CustomNavigationBarModifier(
                centerView: centerView,
                leftView: { EmptyView() },
                rightView: rightView
            )
        )
    }
    func customNavigationBar<C,L>(
        leftView: @escaping (()-> L),
        centerView: @escaping (()-> C)
    ) -> some View where C : View, L: View {
        modifier(
            CustomNavigationBarModifier(
                centerView: centerView,
                leftView: leftView,
                rightView: { EmptyView() }
            )
        )
    }
}
