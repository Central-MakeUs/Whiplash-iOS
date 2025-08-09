//
//  AlarmCardFeature.swift
//  Whiplash-iOS
//
//  Created by 남경민 on 8/2/25.
//

import Foundation
import ComposableArchitecture

@Reducer
public struct AlarmCardFeature {
    public init() {}
    
    @ObservableState
    public struct State: Equatable, Identifiable {
        public init(alarm: Alarm) { self.alarm = alarm }
        public init() { self.alarm = .sampleData }
        var alarm: Alarm
        public var id: Int { alarm.id }
    }
    
    public enum Action {
        case bindingToggle(Bool)
    }
    
    public var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case let .bindingToggle(onOff):
                state.alarm.isToggleOn = onOff
                // 여기서 서버 업데이트가 필요하면 Effect로 호출
                return .none
            }
        }
    }
}
