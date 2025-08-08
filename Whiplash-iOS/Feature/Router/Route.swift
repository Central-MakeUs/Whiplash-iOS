//
//  Route.swift
//  Whiplash-iOS
//
//  Created by 남경민 on 8/9/25.
//
/*
import Foundation
import ComposableArchitecture

@Reducer
struct Route {
    enum State: Equatable {
        case alarmAdd(AlarmAddFeature.State)
        case alarmDetail(AlarmDetailFeature.State)
        case placePicker(PlacePickerFeature.State)
    }
    enum Action: Equatable {
        case alarmAdd(AlarmAddFeature.Action)
        case alarmDetail(AlarmDetailFeature.Action)
        case placePicker(PlacePickerFeature.Action)
    }
    var body: some ReducerOf<Self> {
        Scope(state: /State.alarmAdd, action: /Action.alarmAdd) { AlarmAddFeature() }
        Scope(state: /State.alarmDetail, action: /Action.alarmDetail) { AlarmDetailFeature() }
        Scope(state: /State.placePicker, action: /Action.placePicker) { PlacePickerFeature() }
    }
}

enum DeepLink { case alarm(id: String), createAlarm }

extension Route.State {
    init?(deepLink: DeepLink) {
        switch deepLink {
        case .createAlarm:       self = .alarmAdd(.init())
        case let .alarm(id):     self = .alarmDetail(.init(id: id))
        }
    }
}
*/
