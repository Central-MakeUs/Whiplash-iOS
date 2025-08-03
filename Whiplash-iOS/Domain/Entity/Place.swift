//
//  Place.swift
//  Whiplash-iOS
//
//  Created by 남경민 on 8/3/25.
//

import Foundation

struct Place {
    var id = UUID()
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
