//
//  SearchPlaceFeature.swift
//  Whiplash-iOS
//
//  Created by 남경민 on 8/3/25.
//

import Foundation
import ComposableArchitecture

@Reducer
public struct SearchPlaceFeature {
    public init() {}

    @ObservableState
    public struct State: Equatable {
        public var query: String = ""
        public var places: [Place] = []
        public var isLoading: Bool = false
        public var selectedPlace: Place? = nil
        public init() {}
    }

    public enum Action {
        case queryChanged(String)
        case searchResponse(Result<[Place], Error>)
        case selectPlace(Place)
        case bindingQuery(String)
        case clear
        case backButtonTapped
        case delegate(Delegate)
        public enum Delegate: Equatable {
            case didSelectPlace(MapStyle)
            case backButtonTapped
        }
    }

    @Dependency(\.placeRepository) var placeRepository

    public var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case let .queryChanged(query):
                Logger.shared.log(category: .ui, "queryChanged: \(query)")
                state.query = query
                state.isLoading = true
                guard !query.isEmpty else {
                    state.places = []
                    state.isLoading = false
                    return .none
                }
                return .run { send in
                    try await Task.sleep(nanoseconds: 300_000_000)
                    do {
                        let places = try await placeRepository.search(query)
                        await send(.searchResponse(.success(places)))
                    } catch {
                        await send(.searchResponse(.failure(error)))
                    }
                }
                .cancellable(id: CancelID.search, cancelInFlight: true)
                
            case let .searchResponse(.success(places)):
                Logger.shared.log(category: .network, "searchResponse success: \(places.count)개")
                var seen = Set<String>()
                  let unique = places.filter {
                    let ok = seen.insert($0.id).inserted
                    if !ok { Logger.shared.log(level: .error, category: .ui, "중복 Place id: \($0.id)") }
                    return ok
                  }
                state.places = places
                state.isLoading = false
                return .none
            case .searchResponse(.failure):
                Logger.shared.log(level: .error, category: .network, " searchResponse error")
                state.places = []
                state.isLoading = false
                return .none
            case let .selectPlace(place):
                Logger.shared.log(category: .ui, "selectPlace: \(place.id)")
                state.selectedPlace = place
                var mapStyle = MapStyle(alarmId: 0,
                                        alarmSound: "nonesound",
                                        place: place,
                                        navigationConfig: .init(style: .leftCenter,
                                                                title: "장소 선택"),
                                        bottomSheetType: .registerPlace,
                                        dim: false)
                return .send(.delegate(.didSelectPlace(mapStyle)))
            case .clear:
                state.query = ""
                state.places = []
                state.selectedPlace = nil
                return .none
            case let .bindingQuery(query):
                state.query = query
                return .none
            case .delegate(_):
                return .none
            case .backButtonTapped:
                return .send(.delegate(.backButtonTapped))
            }
            
        }
    }
}
