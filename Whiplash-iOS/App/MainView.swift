//
//  MainView.swift
//  Whiplash-iOS
//
//  Created by 남경민 on 8/10/25.
//

import SwiftUI
import ComposableArchitecture

struct MainView: View {
    @Bindable var store: StoreOf<MainFeature>
    
    var body: some View {
        NavigationStackStore(
            store.scope(
                state: \.path, action: { .path($0) }
            )
        ) {
            HomeView(store: store.scope(state: \.home, action: \.home))
        } destination: { state in
            switch state {
            case .setAlarm(_):
                CaseLet(/MainFeature.Path.State.setAlarm,
                         action: MainFeature.Path.Action.setAlarm) { store in
                    SetAlarmView(store:store)
                }
            }
        }
    }
}
