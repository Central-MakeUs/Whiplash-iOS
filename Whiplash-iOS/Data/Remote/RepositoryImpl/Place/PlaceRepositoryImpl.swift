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
    public var getPlaceDetail: @Sendable (_ latitude: String, _ longitude: String) async throws -> PlaceDetail
    public init(
        search: @escaping @Sendable (_ query: String) async throws -> [Place],
        getPlaceDetail: @escaping @Sendable (_ latitude: String, _ longitude: String) async throws -> PlaceDetail
    ) {
        self.search = search
        self.getPlaceDetail = getPlaceDetail
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
            },
            getPlaceDetail: { latitude, longitude in
                let response: Response<PlaceDetailDTO> = try await apiClient.request(
                    Response<PlaceDetailDTO>.self,
                    target: .getPlaceDetail(latitude, longitude)
                )
                if response.isSuccess, let dto = response.result {
                    
                    return  dto.toDomain
                    
                } else {
                    throw NSError(domain: "GetPlaceDetail", code: 0, userInfo: [NSLocalizedDescriptionKey: response.message])
                }
            }
        )
    }()
}
