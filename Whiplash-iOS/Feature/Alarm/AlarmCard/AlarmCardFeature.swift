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
        public init(alarm: Alarm, place: Place) {
            self.alarm = alarm
            self.place = place
        }
        public init() {
            self.alarm = .sampleData
            self.place = .sampleData
        }
        var place: Place
        var alarm: Alarm
        public var id: Int { alarm.id }
    }
    
    public enum Action {
        case bindingToggle(Bool)
        case verifyButtonTapped
        case delegate(Delegate)
        public enum Delegate: Equatable {
            case verifyAlarm(MapStyle)
        }
    }
    
    public var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case let .bindingToggle(onOff):
                state.alarm.isToggleOn = onOff
                // 여기서 서버 업데이트가 필요하면 Effect로 호출
                return .none
                
            case .verifyButtonTapped:
                Logger.shared.log(level: .debug,category: .etc, "verifybuttontapped")
                let mapStyle = MapStyle(alarmId: state.alarm.id,
                                        alarmSound: state.alarm.soundType,
                                        place: Place(name: state.place.name,
                                                     address: state.place.address,
                                                     latitude: state.place.latitude,
                                                     longitude: state.place.longitude),
                                        navigationConfig: NavigationConfig(style: .leftCenter,
                                                                           title: "도착 인증"),
                                        bottomSheetType: .verifyLocation,
                                        dim: false)
                Logger.shared.log(category: .ui, "🔴 MapStyle 생성: \(mapStyle)")
                Logger.shared.log(category: .ui, "🔴 .delegate(.verifyAlarm) 전송 시작...")
                
                let effect = Effect<Action>.send(.delegate(.verifyAlarm(mapStyle)))
                Logger.shared.log(category: .ui, "🔴 Effect 생성됨: \(effect)")
                
                return effect
                
            case let .delegate(delegateAction):
                Logger.shared.log(category: .ui, "🔴 AlarmCardFeature.delegate 처리: \(delegateAction)")
                return .none
            }
        }
    }
}

