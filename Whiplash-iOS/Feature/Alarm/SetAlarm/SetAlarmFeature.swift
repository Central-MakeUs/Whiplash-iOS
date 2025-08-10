//
//  SetAlarmFeature.swift
//  Whiplash-iOS
//
//  Created by 남경민 on 8/10/25.
//

import Foundation
import ComposableArchitecture

@Reducer
public struct SetAlarmFeature {
    public init() {}
    
    @ObservableState
    public struct State: Equatable {
        public init() {}
        // 여기에 입력 값들(시간/장소/목적 등) 상태를 점차 옮겨오면 됨
        var place: Place = .emptyData
        var alarm: Alarm = .emptyData
        
        var ampm: Ampm = .am
        var hour: Int = 1
        var minute: Int = 0
        var selectedDays: Set<Weekday> = []
        
        var formattedTime: String {
            String(format: "%02d:%02d", hour, minute)
        }
        var repeatDaysString: String {
            selectedDays.sorted { $0.rawValue < $1.rawValue }.map(\.label).joined(separator: ", ")
        }
        var repeatDaysArray: [String] {
            selectedDays.sorted { $0.rawValue < $1.rawValue }.map(\.label)
        }
        
        var canSave: Bool = false
        
    }
    
    public enum Action: BindableAction {
        case onAppear
        case saveTapped
        case closeTapped
        case searchBarTapped
        case backButtonTapped
        case binding(BindingAction<State>)
        
        case setAmpm(Ampm)
        case setHour(Int)
        case setMinute(Int)
        case toggleWeekday(Weekday)
        case updateCanSave
        case selectedPlaceName(String)
        case alarmTitle(String)
        case delegate(Delegate)
        case alarmSaveStarted
        case alarmSaveSucceeded
        case alarmSaveFailed(Error)
        public enum Delegate: Equatable {
            case didCreateAlarm
            case searchPlace
            case backButtonTapped
        }
    }
    
    @Dependency(\.alarmRepository) var alarmRepository
    
    public var body: some ReducerOf<Self> {
        
        BindingReducer()
        
        Reduce { state, action in
            
            func syncAlarmPreview() {
                state.alarm.ampm = state.ampm.rawValue
                state.alarm.time = state.formattedTime
                state.alarm.repeatDays = state.repeatDaysString
                state.alarm.address = state.place.address
                Logger.shared.log(level: .debug, category: .etc, "sync 확인 : \(state.alarm)")
            }
            
            switch action {
            case .onAppear:
                return updateCanSaveState()
                
            case .saveTapped:
                guard state.canSave else {
                    Logger.shared.log(level: .debug, category: .etc, "저장 조건 미충족")
                    return .none
                }
                
                // 저장할 데이터 캡처
                let alarm = state.alarm
                let place = state.place
                
                Logger.shared.log(level: .debug, category: .etc, "알람 저장 시작")
                
                return .run { send in
                    await send(.alarmSaveStarted)
                    
                    do {

                        try await alarmRepository.addAlarm(alarm, place)
                        
                        // 성공 시
                        await send(.alarmSaveSucceeded)
                        
                    } catch {
                        // 실패 시
                        await send(.alarmSaveFailed(error))
                    }
                }
                
            case .alarmSaveStarted:
                Logger.shared.log(level: .debug, category: .etc, "저장 시작됨")
                return .none
                
            case .alarmSaveSucceeded:
                Logger.shared.log(level: .debug, category: .etc, "알람 저장 성공!")
                return .send(.delegate(.didCreateAlarm))
                
            case let .alarmSaveFailed(error):
                Logger.shared.log(level: .error, category: .etc, "알람 저장 실패: \(error.localizedDescription)")
                return .none
                
            case .searchBarTapped:
                return .send(.delegate(.searchPlace))
                
            case .closeTapped:
                return .none
                
            case .backButtonTapped:
                return .send(.delegate(.backButtonTapped))
                
            case .delegate:
                return .none
                
            case let .setAmpm(ampm):
                state.ampm = ampm
                syncAlarmPreview()
                return updateCanSaveState()
                
            case let .setHour(hour):
                state.hour = hour
                syncAlarmPreview()
                return updateCanSaveState()
                
            case let .setMinute(minute):
                state.minute = minute
                syncAlarmPreview()
                return updateCanSaveState()
                
            case let .toggleWeekday(day):
                if state.selectedDays.contains(day) {
                    state.selectedDays.remove(day)
                } else {
                    state.selectedDays.insert(day)
                }
                syncAlarmPreview()
                return updateCanSaveState()
                
            case let .alarmTitle(title):
                state.alarm.title = title
                return updateCanSaveState()
                
            case let .selectedPlaceName(name):
                state.place.name = name
                return updateCanSaveState()
                
            case .updateCanSave:
                return updateCanSaveState()
                
            case .binding(_):
                return .none
            }
            
            func updateCanSaveState() -> Effect<Action> {
                let hasPlace = !state.place.name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
                let hasAlarmTitle = !state.alarm.title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
                let hasValidTime = true
                let hasSelectedDays = !state.selectedDays.isEmpty
                
                let newCanSave = hasPlace && hasAlarmTitle && hasValidTime && hasSelectedDays
                Logger.shared.log(level: .debug, category: .etc, "저장 버튼 상태 변경: \(newCanSave)")
                Logger.shared.log(level: .debug, category: .etc, "- 장소: \(hasPlace)")
                Logger.shared.log(level: .debug, category: .etc, "- 제목: \(hasAlarmTitle)")
                Logger.shared.log(level: .debug, category: .etc, "- 요일: \(hasSelectedDays)")
                if state.canSave != newCanSave {
                    state.canSave = newCanSave
                    Logger.shared.log(level: .debug, category: .etc, "--저장 버튼 상태 변경: \(newCanSave)")
                    Logger.shared.log(level: .debug, category: .etc, "--- 장소: \(hasPlace)")
                    Logger.shared.log(level: .debug, category: .etc, "--- 제목: \(hasAlarmTitle)")
                    Logger.shared.log(level: .debug, category: .etc, "--- 요일: \(hasSelectedDays)")
                }
                
                return .none
            }
        }
    }
}
