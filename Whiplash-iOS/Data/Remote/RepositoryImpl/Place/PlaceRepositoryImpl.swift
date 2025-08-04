//
//  PlaceRepositoryImpl.swift
//  Whiplash-iOS
//
//  Created by 남경민 on 8/3/25.
//

import Foundation
import ComposableArchitecture

public struct PlaceRepositoryImpl: PlaceRepository {
    public var search: @Sendable (_ query: String) async throws -> [Place]
    public init(
        search: @escaping @Sendable (_ query: String) async throws -> [Place]
    ) {
        self.search = search
    }
}

extension PlaceRepositoryImpl: DependencyKey {
    public static let liveValue: Self = {
        let apiClient = APIClient()
        return Self(
            search: { query in
                let response: Response<[PlaceResponseDTO]> = try await apiClient.request(
                    Response<[PlaceResponseDTO]>.self,
                    target: .searchPlace(query)
                )
                return response.result?.map { $0.toDomain } ?? []
            }
        )
    }()
}
