//
//  PlaceRepository.swift
//  Whiplash-iOS
//
//  Created by 남경민 on 8/3/25.
//

import Foundation

public protocol PlaceRepository {
    var search: @Sendable (_ query: String) async throws -> [Place] { get }
    var getPlaceDetail: @Sendable (_ latitude: String, _ longitude: String) async throws -> PlaceDetail { get }
}
