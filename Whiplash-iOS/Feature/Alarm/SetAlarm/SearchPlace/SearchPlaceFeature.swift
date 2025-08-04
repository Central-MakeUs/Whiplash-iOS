//
//  SearchPlaceFeature.swift
//  Whiplash-iOS
//
//  Created by 남경민 on 8/3/25.
//

import Foundation
import ComposableArchitecture

@Reducer
public struct SearchLocationFeature {
    public init() {}

    @ObservableState
    public struct State {
        public var query: String = ""
        public var results: [Place] = []
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
    }

    @Dependency(\.placeRepository) var placeRepository

    public var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case let .queryChanged(query):
                state.query = query
                state.isLoading = true
                guard !query.isEmpty else {
                    state.results = []
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
            case let .searchResponse(.success(places)):
                state.results = places
                state.isLoading = false
                return .none
            case .searchResponse(.failure):
                state.results = []
                state.isLoading = false
                return .none
            case let .selectPlace(place):
                state.selectedPlace = place
                return .none
            case .clear:
                state.query = ""
                state.results = []
                state.selectedPlace = nil
                return .none
            case let .bindingQuery(query):
                state.query = query
                return .none
            }
            
        }
    }
}
