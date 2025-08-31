//
//  LocationClient.swift
//  Whiplash-iOS
//
//  Created by 남경민 on 8/9/25.
//

import Foundation
import CoreLocation
import ComposableArchitecture

struct LocationClient {
    var requestWhenInUseAuthorization: () async -> Void
    var authorizationStatusStream: () async -> AsyncStream<CLAuthorizationStatus>
    var locationStream: () async -> AsyncStream<CLLocationCoordinate2D>
}

extension LocationClient: DependencyKey {
    static let liveValue = LocationClient(
        requestWhenInUseAuthorization: {
            await LocationManager.shared.requestWhenInUseAuthorization()
        },
        authorizationStatusStream: {
            await LocationManager.shared.authorizationStatusStream()
        },
        locationStream: {
            await LocationManager.shared.locationStream()
        }
    )
    /*
    static let testValue = LocationClient(
        requestWhenInUseAuthorization: {
            // Test implementation
        },
        authorizationStatusStream: {
            AsyncStream { continuation in
                continuation.yield(.authorizedWhenInUse)
                continuation.finish()
            }
        },
        locationStream: {
            AsyncStream { continuation in
                // Test location (강남역)
                continuation.yield(CLLocationCoordinate2D(latitude: 37.4979, longitude: 127.0276))
                continuation.finish()
            }
        }
    )*/
}
