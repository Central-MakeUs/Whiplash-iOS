//
//  MapStyle.swift
//  Whiplash-iOS
//
//  Created by 남경민 on 8/10/25.
//

import Foundation

public struct MapStyle: Equatable {
    var alarmId: Int
    var alarmSound: String
    var place: Place
    var navigationConfig: NavigationConfig
    var bottomSheetType: BottomSheetType
    var dim: Bool
}

extension MapStyle {
    static let sampleData: MapStyle = .init(
        alarmId: 0,
        alarmSound: "sound1",
        place: .init(
            name: "유림면",
            address: "서울특별시 중구 서소문동 16",
            latitude: 37.5642371,
            longitude: 126.9760935
        ),
        navigationConfig: .init(
            style: .leftCenter,
            title: "장소 선택"),
        bottomSheetType: .registerPlace,
        dim: false
    )
    static let sampleData2: MapStyle = .init(
        alarmId: 0,
        alarmSound: "sound1",
        place: .init(
            name: "유림면",
            address: "서울특별시 중구 서소문동 16",
            latitude: 37.5642371,
            longitude: 126.9760935
        ),
        navigationConfig: .init(
            style: .center,
            title: "위치"),
        bottomSheetType: .ringAlarm,
        dim: true
    )
}

public enum NavBarStyle: Equatable {
    case leftCenter
    case center
    case hidden
}

public enum BottomSheetType: Equatable {
    case registerPlace
    case ringAlarm
    case confirmInactive
    case cantUseInactive
    case verifyLocation
    case verifyingLocation
    case cantVerifyLocation
    case none
}

public struct NavigationConfig: Equatable {
    public var style: NavBarStyle
    public var title: String
    public init(style: NavBarStyle, title: String) {
        self.style = style
        self.title = title
    }
}
