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
struct MapFeature {
    @ObservableState
    struct State: Equatable {
        var place: Place = .sampleData
        var currentLocation: CLLocationCoordinate2D?
        var authorizationStatus: CLAuthorizationStatus = .notDetermined
        var isLocationAuthorized = false
        var isRegistrationSheetPresented = true
        var circleRadius: Double = 100.0
        var locationError: String?
    }
    
    enum Action: Equatable {
        case onAppear
        case requestLocationPermission
        case locationAuthorizationChanged(CLAuthorizationStatus)
        case locationUpdated(CLLocationCoordinate2D)
        case locationError(String)
        case setTestLocation
        //case mapTapped(CLLocationCoordinate2D)
        case registrationSheet(Bool)
        case registerPlace(String)
        case cancelAction
    }
    
    @Dependency(\.locationClient) var locationClient
    
    var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case .onAppear:
                return Effect<Action>.send(.requestLocationPermission)
                
            case .requestLocationPermission:
                return .merge(
                    // 권한 상태 스트림 구독
                    .run { send in
                        for await status in await locationClient.authorizationStatusStream() {
                            await send(.locationAuthorizationChanged(status))
                        }
                    },
                    // 권한 요청
                    .run { _ in
                        await locationClient.requestWhenInUseAuthorization()
                    },
                    // 5초 후 테스트 위치 설정
                    .run { send in
                        try await Task.sleep(nanoseconds: 5_000_000_000)
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
            /*
            case let .mapTapped(coord):
                if let current = state.currentLocation {
                    let distance = coord.distance(from: current)
                    if distance <= state.circleRadius {
                        return Effect<Action>.send(.registrationSheet)
                    }
                }
                return .none
                */
            case let .registrationSheet(status):
                state.isRegistrationSheetPresented = status
                return .none
                
            case let .registerPlace(name):
                state.place.name = name
                state.isRegistrationSheetPresented = false
                return .none
                
            case .cancelAction:
                return .none
            }
        }
    }
}
