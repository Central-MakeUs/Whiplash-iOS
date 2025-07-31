//
//  Whiplash_iOSApp.swift
//  Whiplash-iOS
//
//  Created by 남경민 on 6/24/25.
//

import SwiftUI
import ComposableArchitecture

@main
struct Whiplash_iOSApp: App {
    var body: some Scene {
        WindowGroup {
            LoginView(store: Store(initialState: LoginFeature.State(), reducer: { LoginFeature() }))
        }
    }
}
