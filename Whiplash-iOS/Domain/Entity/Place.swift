//
//  Place.swift
//  Whiplash-iOS
//
//  Created by 남경민 on 8/3/25.
//

import Foundation

public struct Place: Identifiable, Equatable, Hashable {
    public var id: String { "\(name)|\(address)|\(latitude)|\(longitude)" }
    var name: String
    var address: String
    var latitude: Double
    var longitude: Double
}

extension Place {
    static let sampleData: Place = .init(
        name: "유림면",
        address: "서울특별시 중구 서소문동 16",
        latitude: 37.5642371,
        longitude: 126.9760935
    )
}

public struct PlaceList {
    var placeList: [Place]
}

extension PlaceList {
    static let sampleData: PlaceList = .init(placeList: [
        .init(
            name: "유림면",
            address: "서울특별시 중구 서소문동 16",
            latitude: 37.5642371,
            longitude: 126.9760935
        ),
        .init(
            name: "유림면",
            address: "서울특별시 중구 서소문동 16",
            latitude: 37.5642371,
            longitude: 126.9760935
        )
        ,.init(
            name: "유림면",
            address: "서울특별시 중구 서소문동 16",
            latitude: 37.5642371,
            longitude: 126.9760935
        )
        
    ])
}

public struct PlaceDetail: Equatable {
    var name: String
    var address: String
}

extension PlaceDetail {
    static let sampleData: PlaceDetail = .init(
        name: "유림면",
        address: "서울특별시 중구 서소문동 16"
    )
}
