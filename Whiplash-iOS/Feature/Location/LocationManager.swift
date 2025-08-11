//
//  LocationManager.swift
//  Whiplash-iOS
//
//  Created by 남경민 on 8/9/25.
//

import SwiftUI
import CoreLocation

@MainActor
class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    static let shared = LocationManager()
    
    private let locationManager = CLLocationManager()
    private var authorizationContinuation: AsyncStream<CLAuthorizationStatus>.Continuation?
    private var locationContinuation: AsyncStream<CLLocationCoordinate2D>.Continuation?
    
    @Published var authorizationStatus: CLAuthorizationStatus = .notDetermined
    @Published var currentLocation: CLLocation?
    
    private override init() {
        super.init()
        locationManager.delegate = self
        //locationManager.allowsBackgroundLocationUpdates = true
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.pausesLocationUpdatesAutomatically = false
        locationManager.showsBackgroundLocationIndicator = true
        authorizationStatus = locationManager.authorizationStatus
        
        Logger.shared.log(level: .debug, category: .etc, "Core.LocationManager 초기화됨")
    }
    
    func requestWhenInUseAuthorization() {
        Logger.shared.log(level: .debug, category: .etc, "위치 권한 요청")
        
        DispatchQueue.global(qos: .utility).async {
            if CLLocationManager.locationServicesEnabled() {
                DispatchQueue.main.async {
                    Logger.shared.log(level: .debug, category: .etc, "기기 위치 서비스 활성화됨")
                    self.locationManager.requestWhenInUseAuthorization()
                }
            } else {
                Logger.shared.log(level: .debug, category: .etc, "기기 위치 서비스 비활성화됨")
            }
        }
    }
    
    func authorizationStatusStream() -> AsyncStream<CLAuthorizationStatus> {
        AsyncStream { continuation in
            self.authorizationContinuation = continuation
            continuation.yield(locationManager.authorizationStatus) // 현재 상태 즉시 전송
        }
    }
    
    func locationStream() -> AsyncStream<CLLocationCoordinate2D> {
        AsyncStream { continuation in
            self.locationContinuation = continuation
            
            if authorizationStatus == .authorizedWhenInUse || authorizationStatus == .authorizedAlways {
                Logger.shared.log(level: .debug, category: .etc, "위치 업데이트 시작")
                locationManager.startUpdatingLocation()
            }
            
            continuation.onTermination = { _ in
                Task { @MainActor in
                    self.locationManager.stopUpdatingLocation()
                    Logger.shared.log(level: .debug, category: .etc, "위치 업데이트 중지")
                }
            }
        }
    }
    
    // MARK: - CLLocationManagerDelegate
    nonisolated func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        Task { @MainActor in
            Logger.shared.log(level: .debug, category: .etc, "권한 상태 변경: \(status.rawValue)")
            
            self.authorizationStatus = status
            self.authorizationContinuation?.yield(status)
            
            switch status {
            case .authorizedWhenInUse, .authorizedAlways:
                Logger.shared.log(level: .debug, category: .etc, "권한 승인됨!")
                self.locationManager.startUpdatingLocation()
            case .denied:
                Logger.shared.log(level: .debug, category: .etc, "권한 거부됨")
            case .restricted:
                Logger.shared.log(level: .debug, category: .etc, "권한 제한됨")
            case .notDetermined:
                Logger.shared.log(level: .debug, category: .etc, "권한 아직 미결정")
            @unknown default:
                Logger.shared.log(level: .debug, category: .etc, "알 수 없는 권한 상태")
            }
        }
    }
    
    nonisolated func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        Task { @MainActor in
            guard let location = locations.last else {
                Logger.shared.log(level: .debug, category: .etc, "위치 데이터 없음")
                return
            }
            
            Logger.shared.log(level: .debug, category: .etc, "위치 업데이트: \(location.coordinate)")
            
            self.currentLocation = location
            self.locationContinuation?.yield(location.coordinate)
        }
    }
    
    nonisolated func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        Task { @MainActor in
            Logger.shared.log(level: .debug, category: .etc, "위치 업데이트 실패: \(error.localizedDescription)")
        }
    }
}

enum LocationError: Error, Equatable {
    case permissionDenied
    case permissionRestricted
    case serviceDisabled
    case unknown(String)
    
    var localizedDescription: String {
        switch self {
        case .permissionDenied:
            return "위치 권한이 거부되었습니다."
        case .permissionRestricted:
            return "위치 권한이 제한되어 있습니다."
        case .serviceDisabled:
            return "위치 서비스가 비활성화되어 있습니다."
        case .unknown(let message):
            return "위치 오류: \(message)"
        }
    }
}
