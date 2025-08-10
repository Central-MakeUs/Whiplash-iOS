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
        var mapStyle: MapStyle = .sampleData
        var selectedLocation: CLLocationCoordinate2D?
        var currentLocation: CLLocationCoordinate2D?
        var updatedPlace: PlaceDetail = .sampleData
        var authorizationStatus: CLAuthorizationStatus = .notDetermined
        var isLocationAuthorized = false
        var isRegistrationSheetPresented = true
        var circleRadius: Double = 100.0
        var isSheetPresented = false
        var locationError: String?
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
        case registrationSheet(Bool)
        case registerPlace
        case backButtonTapped
        case cancelAction
        case placeDetailResponse(Result<PlaceDetail, Error>)
        case delegate(Delegate)
        
        public enum Delegate: Equatable {
            case backButtonTapped
            case registerPlace(Place)
        }
    }
    
    @Dependency(\.locationClient) var locationClient
    @Dependency(\.placeRepository) var placeRepository
    
    public var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case .onAppear:
                return Effect<Action>.send(.requestLocationPermission)
                
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
                
            case let .registrationSheet(status):
                state.isRegistrationSheetPresented = status
                return .none
                
            case .registerPlace:
                let place = Place(name: state.updatedPlace.name,
                                  address: state.updatedPlace.address,
                                  latitude: state.selectedLocation?.latitude ?? 0,
                                  longitude: state.selectedLocation?.longitude ?? 0)
                
                return .send(.delegate(.registerPlace(place)))
                
            case .cancelAction:
                return .none
                
            case .delegate:
                return .none
                
            case .backButtonTapped:
                return .send(.delegate(.backButtonTapped))
                
            }
        }
    }
}
