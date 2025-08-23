//
//  MainFeature.swift
//  Whiplash-iOS
//
//  Created by 남경민 on 8/10/25.
//

import Foundation
import ComposableArchitecture

@Reducer
struct MainFeature {
    @ObservableState
    struct State: Equatable {
        var home = HomeFeature.State()
        var path = StackState<Path.State>()
    }
    
    @CasePathable
    enum Action: BindableAction {
        case home(HomeFeature.Action)
        case path(StackAction<Path.State, Path.Action>)
        case binding(BindingAction<State>)
        case delegate(Delegate)
        // 알람 화면 관련 액션 추가
        case showAlarmScreen(Int, String)           // 알람 화면 표시
        case hideAlarmScreen                // 알람 화면 숨김
        //case alarmMap(MapFeature.Action)    // 알람 MapView 액션
        
    }
    
    public enum Delegate: Equatable {
        case logout
        case signout
    }
    
    struct Path: Reducer {
        enum State: Equatable {
            case setAlarm(SetAlarmFeature.State)
            case searchPlace(SearchPlaceFeature.State)
            case selectPlace(MapFeature.State)
            case setting(SettingFeature.State)
        }
        enum Action {
            case setAlarm(SetAlarmFeature.Action)
            case searchPlace(SearchPlaceFeature.Action)
            case selectPlace(MapFeature.Action)
            case setting(SettingFeature.Action)
        }
        var body: some ReducerOf<Self> {
            Scope(state: /State.setAlarm, action: /Action.setAlarm) {
                SetAlarmFeature()
            }
            Scope(state: /State.searchPlace, action: /Action.searchPlace) {
                SearchPlaceFeature()
            }
            Scope(state: /State.selectPlace, action: /Action.selectPlace){
                MapFeature()
            }
            Scope(state: /State.setting, action: /Action.setting){
                SettingFeature()
            }
        }
    }
    
    var body: some ReducerOf<Self> {
        BindingReducer()
        
        Scope(state: \.home, action: \.home) {
            HomeFeature()
        }
        
        Reduce { state, action in
            switch action {
            case .home(.delegate(.addAlarmTapped)):
                state.path.append(.setAlarm(.init()))
                return .none
                
            case .home(.delegate(.moveToSetting)):
                state.path.append(.setting(.init()))
                return .none
                
            case let .home(.delegate(.verifyAlarm(mapStyle))):
                Logger.shared.log(category: .ui, "verifyAlarm 수신됨! MapStyle: \(mapStyle)")
                
                Logger.shared.log(level: .debug,category: .etc, "홈에서 메인으로 델리게이트 넘어옴")
                state.path.append(.selectPlace(.init(
                    mapStyle: mapStyle
                )))
                return .none
                
            case .path(.element(_, action: .setting(.delegate(.logout)))):
                Logger.shared.log(level: .debug, category: .etc, "메인에서 로그아웃 수신됨")
                return .send(.delegate(.logout))
                
            case .path(.element(_, action: .setting(.delegate(.signout)))):
                Logger.shared.log(level: .debug, category: .etc, "메인에서 회원탈퇴 수신됨")
                return .send(.delegate(.signout))
                
            case .path(.element(_, action: .setAlarm(.delegate(.searchPlace)))):
                state.path.append(.searchPlace(.init()))
                return .send(.home(.onAppear))
                
            case .path(.element(_, action: .searchPlace(.delegate(.backButtonTapped)))):
                state.path.popLast()
                return .send(.home(.onAppear))
                
            case .path(.element(_, action: .setAlarm(.delegate(.didCreateAlarm)))):
                state.path.popLast()
                return .send(.home(.onAppear))
                
            case .path(.element(_, action: .setAlarm(.delegate(.backButtonTapped)))):
                state.path.popLast()
                return .send(.home(.onAppear))
                
            case .path(.element(_, action: .setting(.delegate(.backButtonTapped)))):
                state.path.popLast()
                return .send(.home(.onAppear))
                
            case let .path(.element(_, action: .searchPlace(.delegate(.didSelectPlace(mapStyle))))):
                state.path.append(.selectPlace(.init(
                    mapStyle: mapStyle
                )))
                return .none
                
            case let .path(.element(id, action: .selectPlace(.delegate(.registerPlace(place))))):
                for index in state.path.ids {
                    if case var .setAlarm(setAlarmState) = state.path[id: index] {
                        Logger.shared.log(level: .debug, category: .etc, "index: \(index)")
                        Logger.shared.log(level: .debug, category: .etc, ".setAlarm(setAlarmState): \(state.path[id: index])")
                        setAlarmState.place = place
                        Logger.shared.log(level: .debug, category: .etc, "setAlarmState.place \(setAlarmState.place)")
                        state.path[id: index] = .setAlarm(setAlarmState)
                        Logger.shared.log(level: .debug, category: .etc, ".setAlarm(setAlarmState): \(state.path[id: index])")
                        break
                    }
                }
                state.path.popLast()
                state.path.popLast()
                return .none
                
            case .path(.element(_, action: .selectPlace(.delegate(.backButtonTapped)))):
                state.path.popLast()
                return .none
                
                
            case .path, .home:
                return .none
                
            case .binding(_):
                return .none
            case .delegate(_):
                return .none
                
                // 🔥 알람 화면 표시 (핵심!)
            case let .showAlarmScreen(alarmId, soundId):
                Logger.shared.log(category: .ui, "🚨 HomeFeature에서 알람 화면 표시: \(alarmId)")
                
                // 알람 ID로 실제 알람 정보 조회
                guard let alarm = state.home.card.first(where: { $0.alarm.id == alarmId }) else {
                    Logger.shared.log(category: .ui, "⚠️ 알람 ID \(alarmId)에 해당하는 알람을 찾을 수 없음")
                    return .none
                }
                guard let place = state.home.card.first(where: { $0.place.address == alarm.alarm.address }) else {
                    Logger.shared.log(category: .ui, "⚠️ 플레이스를 찾을 수 없음")
                    return .none
                }
                
                // 알람 정보로 MapStyle 생성
                let alarmMapStyle = createAlarmMapStyle(alarm: alarm.alarm, place: place.place, alarmSoundId: soundId)
                
                state.path.append(.selectPlace(.init(
                    mapStyle: alarmMapStyle
                )))
                
                Logger.shared.log(category: .ui, "✅ 알람 화면 표시 완료")
                
                return .none
                
                // 🔥 알람 화면 숨김
            case .hideAlarmScreen:
                Logger.shared.log(category: .ui, "🚨 HomeFeature에서 알람 화면 숨김")
                
                //state.alarmMapState = nil
                //state.isShowingAlarmScreen = false
                
                return .none
                
            }
        }
        .forEach(\.path, action: \.path) {
            Path()
        }
    }
    // 🔥 알람 정보로 MapStyle 생성하는 헬퍼 함수
    private func createAlarmMapStyle(alarm: Alarm, place: Place, alarmSoundId: String) -> MapStyle {
        // Alarm 모델의 place 정보 사용
        let place = Place(
            name: place.name ?? "알람 위치",
            address: place.address,
            latitude: place.latitude ?? 37.4979,
            longitude: place.longitude ?? 127.0276
        )
        
        return MapStyle(
            alarmId: alarm.id,
            alarmSound: alarmSoundId,
            place: place,
            navigationConfig: NavigationConfig(
                style: .center,
                title: alarm.title
            ), bottomSheetType: .ringAlarm,  // 알람이 울릴 때는 RingAlarmView
            dim: true
        )
    }
}

@Reducer
struct Destination {
    @ObservableState
    enum State: Equatable {
        case setAlarm(SetAlarmFeature.State)
    }
    
    @CasePathable
    enum Action {
        case setAlarm(SetAlarmFeature.Action)
    }
    
    var body: some ReducerOf<Self> {
        Scope(state: \.setAlarm, action: \.setAlarm) {
            SetAlarmFeature()
        }
    }
}
