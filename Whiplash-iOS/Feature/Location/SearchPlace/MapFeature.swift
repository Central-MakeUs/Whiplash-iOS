//
//  MapFeature.swift
//  Whiplash-iOS
//
//  Created by 남경민 on 8/6/25.
//

import SwiftUI
import ComposableArchitecture
import NMapsMap
import CoreLocation

@Reducer
public struct MapFeature {
    @ObservableState
    public struct State: Equatable {
        init(mapStyle: MapStyle) {
            self.mapStyle = mapStyle
            self.isSheetPresented = mapStyle.bottomSheetType != .none
            self.selectedLocation = CLLocationCoordinate2D(
                latitude: mapStyle.place.latitude,
                longitude: mapStyle.place.longitude
            )
            self.updatedPlace.name = mapStyle.place.name
            self.updatedPlace.address = mapStyle.place.address
        }
        var mapStyle: MapStyle = .sampleData2
        var selectedLocation: CLLocationCoordinate2D?
        var currentLocation: CLLocationCoordinate2D?
        var updatedPlace: PlaceDetail = .sampleData
        var authorizationStatus: CLAuthorizationStatus = .notDetermined
        var isLocationAuthorized = false
        var isRegistrationSheetPresented = true
        var circleRadius: Double = 100.0
        var isSheetPresented = false
        var showSuccessView = false
        var locationError: String?
        var remainingOffCount: Int = 2
        var bottomSheetHeight: CGFloat = 232
    }
    
    public enum Action {
        case onAppear
        case requestLocationPermission
        case locationAuthorizationChanged(CLAuthorizationStatus)
        case locationUpdated(CLLocationCoordinate2D)
        case locationError(String)
        case setTestLocation
        case mapTapped(CLLocationCoordinate2D)
        case setSheetPresented(Bool)
        case setBottomSheetHeight(CGFloat)
        case registrationSheet(Bool)
        case registerPlace
        case moveToSuccess
        case backButtonTapped
        case cancelAction
        case placeDetailResponse(Result<PlaceDetail, Error>)
        case changeBottomSheetType(BottomSheetType)
        case startVerification      // onConfirm 버튼 클릭
        case verificationCompleted  // 인증 완료 (3초 후)
        case didFinishVerify(Result<Void, Error>)
        case getRemainingOffCount(Int)
        
        case alarmOffButtonTapped
        case didFinishAlarmOff(Result<Void, Error>)
        
        case updateHeight(BottomSheetType)
        case calculateHeight(BottomSheetType)
        case delegate(Delegate)
        
        case startInAppRinging
        case stopInAppRinging
        
        case successTapped
        
        public enum Delegate: Equatable {
            case backButtonTapped
            case registerPlace(Place)
            case successOff
        }
    }
    
    @Dependency(\.locationClient) var locationClient
    @Dependency(\.placeRepository) var placeRepository
    @Dependency(\.alarmRepository) var alarmRepository
    @Dependency(\.notificationClient) var notificationClient
    @Dependency(\.alarmSound) var alarmSound
    
    public var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case .onAppear:
                let bottomsheet = state.mapStyle.bottomSheetType
                let alarmId = state.mapStyle.alarmId
                let alarmSound = state.mapStyle.alarmSound
                return .run { send in
                let offCount = try await alarmRepository.offCount()
                await send(.getRemainingOffCount(offCount))
                await send(.requestLocationPermission)
                if bottomsheet == .ringAlarm {
                    print("알람재등록")
                    let notificationAlarm = NotificationAlarm(id: alarmId,
                                                              title: "",
                                                              hour: 0,
                                                              minute: 0,
                                                              weekdays: [],
                                                              soundName: alarmSound)
                    try await notificationClient.scheduleRepeatingAlarm(notificationAlarm, 10, 64)
                    // 앱이 열려있다면 즉시 무한 루프 재생 시작
                    await send(.startInAppRinging)
                }
                    
                }
                
            case .startInAppRinging:
                print("화면으롤 넘어온 알람 사운드 \(state.mapStyle.alarmSound)")
                let sound = state.mapStyle.alarmSound.isEmpty ? "sound1" : state.mapStyle.alarmSound
                return .run { _ in
                    await alarmSound.play(sound)
                }
                
            case .stopInAppRinging:
                return .run { _ in
                    await alarmSound.stop()
                }
                
            case let .getRemainingOffCount(count):
                state.remainingOffCount = count
                return .none
                
            case .alarmOffButtonTapped:
                let alarmId = state.mapStyle.alarmId
                return .run { send in
                    
                    await send(.didFinishAlarmOff(
                        Result {
                            try await alarmRepository.alarmOff(alarmId)
                        }
                    ))
                }
                
            case .didFinishAlarmOff(.success()):
                let alarmId = state.mapStyle.alarmId
                return .run { send in
                    try await notificationClient.cancelRepeatingAlarm(alarmId)
                    await send(.stopInAppRinging)
                    await send(.backButtonTapped)
                }
                
            case .didFinishAlarmOff(.failure):
                return .send(.changeBottomSheetType(.cantUseInactive))
                
                
            case .requestLocationPermission:
                Logger.shared.log(level: .debug, category: .etc, "위치 권한 요청 시작")
                return .merge(
                    .run { send in
                        for await status in await locationClient.authorizationStatusStream() {
                            Logger.shared.log(level: .debug, category: .etc, "권한 상태 변경: \(status.rawValue)")
                            await send(.locationAuthorizationChanged(status))
                        }
                    },
                    
                        .run { _ in
                            Logger.shared.log(level: .debug, category: .etc, "권한 요청 시작")
                            await locationClient.requestWhenInUseAuthorization()
                        },
                    
                        .run { send in
                            for await location in await locationClient.locationStream() {
                                Logger.shared.log(level: .debug, category: .etc, "위치 업데이트: \(location)")
                                await send(.locationUpdated(location))
                            }
                        },
                    
                        .run { send in
                            try await Task.sleep(nanoseconds: 2_000_000_000)
                            await send(.setTestLocation)
                        }
                )
                
            case let .locationAuthorizationChanged(status):
                state.authorizationStatus = status
                state.isLocationAuthorized = (status == .authorizedWhenInUse || status == .authorizedAlways)
                
                if state.isLocationAuthorized {
                    return .run { send in
                        for await location in await locationClient.locationStream() {
                            await send(.locationUpdated(location))
                        }
                    }
                } else if status == .denied {
                    state.locationError = "위치 권한이 거부되었습니다. 설정에서 권한을 허용해주세요."
                }
                return .none
                
            case let .locationUpdated(coord):
                state.currentLocation = coord
                state.locationError = nil
                return .none
                
            case let .locationError(message):
                state.locationError = message
                return .none
                
            case .setTestLocation:
                if state.currentLocation == nil {
                    let testLocation = CLLocationCoordinate2D(latitude: 37.4979, longitude: 127.0276)
                    return Effect<Action>.send(.locationUpdated(testLocation))
                }
                return .none
                
            case let .mapTapped(coord):
                Logger.shared.log(level: .debug, category: .ui, "map tapped: \(coord)")
                guard state.mapStyle.navigationConfig.style != .center else { return .none }
                
                state.selectedLocation = coord
                
                return .run { [lat = coord.latitude, lng = coord.longitude] send in
                    let result = await Result {
                        try await placeRepository.getPlaceDetail(String(lat), String(lng))
                    }
                    await send(.placeDetailResponse(result))
                }
                .cancellable(id: CancelID.reverseGeocoding, cancelInFlight: true)
                
            case let .placeDetailResponse(.success(place)):
                state.updatedPlace.name = place.name
                state.updatedPlace.address = place.address
                return .none
                
            case let .placeDetailResponse(.failure(error)):
                Logger.shared.log(level: .error, category: .network, "place detail 실패: \(error.localizedDescription)")
                return .none
                
            case let .setSheetPresented(flag):
                state.isSheetPresented = flag
                return .none
                
            case let .setBottomSheetHeight(height):
                state.bottomSheetHeight = height
                return .none
                
            case let .registrationSheet(status):
                state.isRegistrationSheetPresented = status
                return .none
                
            case .registerPlace:
                let place = Place(name: state.updatedPlace.name,
                                  address: state.updatedPlace.address,
                                  latitude: state.selectedLocation?.latitude ?? 0,
                                  longitude: state.selectedLocation?.longitude ?? 0)
                
                return .send(.delegate(.registerPlace(place)))
                
            case .moveToSuccess:
                state.showSuccessView = true
                return .none
                
                
            case let .changeBottomSheetType(type):
                state.mapStyle.bottomSheetType = type
                return .none
                
            case .cancelAction:
                return .none
                
            case .delegate:
                return .none
                
            case .backButtonTapped:
                return .send(.delegate(.backButtonTapped))
            
            case .successTapped:
                return .send(.delegate(.backButtonTapped))
                
                // 🔥 1. 위치 인증 시작 (onConfirm 버튼 클릭)
            case .startVerification:
                Logger.shared.log(category: .ui, "위치 인증 시작")
                
                // 바텀시트를 로딩 상태로 변경
                let selectedLocation = CLLocation(latitude: state.selectedLocation?.latitude ?? 0, longitude: state.selectedLocation?.longitude ?? 0)
                let currentLocation = CLLocation(latitude: state.currentLocation?.latitude ?? 0, longitude: state.currentLocation?.longitude ?? 0)
                state.mapStyle.bottomSheetType = .verifyingLocation
                let alarmId = state.mapStyle.alarmId
                let latitude = state.currentLocation?.latitude ?? state.mapStyle.place.latitude
                let longitude = state.currentLocation?.longitude ?? state.mapStyle.place.longitude
                state.mapStyle.place.latitude = latitude
                state.mapStyle.place.longitude = longitude
                let place = state.mapStyle.place
                return .run { send in
                    
                    let distance = selectedLocation.distance(from: currentLocation)
                    if distance <= 100 {
                        print("✅ 인증 성공: 100m 이내")
                        try await notificationClient.cancelRepeatingAlarm(alarmId)
                        await send(.stopInAppRinging)
                        await send(.verificationCompleted)
                    } else {
                        print("❌ 거리 벗어남: \(distance)m")
                        await send(.changeBottomSheetType(.cantVerifyLocation))
                    }
                }
                
            case .didFinishVerify(.success()):
                let alarmId = state.mapStyle.alarmId
                return .run { send in
                    try await notificationClient.cancelRepeatingAlarm(alarmId)
                    await send(.stopInAppRinging)
                    await send(.verificationCompleted)
                }
                
            case .didFinishVerify(.failure):
                return .send(.changeBottomSheetType(.cantVerifyLocation))
                
            case .verificationCompleted:
                Logger.shared.log(category: .ui, "위치 인증 완료 - 성공 화면 표시")
                
                // 바텀시트 숨기고 성공 화면 표시
                state.mapStyle.bottomSheetType = .none
                state.isSheetPresented = false
                state.showSuccessView = true
                
                return .none
                
                
            case let .updateHeight(type):
                return .send(.calculateHeight(type))
                
                
            case let .calculateHeight(type):
                switch type {
                case .verifyingLocation:
                    state.bottomSheetHeight = 232
                case .verifyLocation:
                    state.bottomSheetHeight = 232
                case .cantVerifyLocation:
                    state.bottomSheetHeight = 332
                case .confirmInactive:
                    state.bottomSheetHeight = 332
                case .cantUseInactive:
                    state.bottomSheetHeight = 362
                case .registerPlace:
                    state.bottomSheetHeight = 232
                case .ringAlarm:
                    state.bottomSheetHeight = 0
                case .none:
                    state.bottomSheetHeight = 232
                }
                return .none
            }
            
        }
    }
    
    func isWithin100m(current: CLLocationCoordinate2D, target: CLLocationCoordinate2D) -> Bool {
        let currentLocation = CLLocation(latitude: current.latitude, longitude: current.longitude)
        let targetLocation = CLLocation(latitude: target.latitude, longitude: target.longitude)
        
        let distance = currentLocation.distance(from: targetLocation) // 미터 단위
        print("📏 거리 = \(distance) m")
        return distance <= 100
    }
}
