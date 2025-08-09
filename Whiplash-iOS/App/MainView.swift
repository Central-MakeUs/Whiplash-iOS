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
        ZStack {
            HomeView(store: store.scope(state: \.home, action: \.home))
        }
        .sheet(
            store: store.scope(state: \.$destination, action: \.destination),
            state: /Destination.State.setAlarm,
            action: Destination.Action.setAlarm
        ) { setAlarmStore in
            SetAlarmView(store: setAlarmStore)
        }
    }
}
