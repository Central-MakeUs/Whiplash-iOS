//
//  NaverMapView.swift
//  Whiplash-iOS
//
//  Created by 남경민 on 8/10/25.
//

import SwiftUI
import ComposableArchitecture
import NMapsMap
import CoreLocation

struct NaverMapView: UIViewRepresentable {
    let selectedLocation: CLLocationCoordinate2D?
    let currentLocation: CLLocationCoordinate2D?
    let circleRadius: Double
    let onMapTap: (CLLocationCoordinate2D) -> Void

    func makeUIView(context: Context) -> NMFMapView {
        let mapView = NMFMapView()
        
        mapView.isNightModeEnabled = true
        mapView.positionMode = .direction
        mapView.mapType = .navi
        
        if #available(iOS 13.0, *) {
            mapView.overrideUserInterfaceStyle = .dark
        }
        
        mapView.touchDelegate = context.coordinator
        
        context.coordinator.onMapTap = onMapTap
        context.coordinator.mapView = mapView
        
        Logger.shared.log(level: .debug, category: .ui, "네이버 맵뷰 생성 완료")
        return mapView
    }
    
    func updateUIView(_ uiView: NMFMapView, context: Context) {
        context.coordinator.onMapTap = onMapTap
        
        guard let location = currentLocation else {
            Logger.shared.log(level: .debug, category: .ui, "현재 위치 없음 - 마커와 원형 표시 안함")
            return
        }
        
        Logger.shared.log(level: .debug, category: .ui, "위치 있음 - 마커와 원형 표시: \(location)")
        
        // 카메라 설정
        if !context.coordinator.isInitialLocationSet {
            if let selectedLocation = selectedLocation {
                let cameraPosition = NMGLatLng(lat: selectedLocation.latitude, lng: selectedLocation.longitude)
                let camera = NMFCameraPosition(cameraPosition, zoom: 16.0)
                let cameraUpdate = NMFCameraUpdate(position: camera)
                uiView.moveCamera(cameraUpdate)
                context.coordinator.isInitialLocationSet = true
                Logger.shared.log(level: .debug, category: .ui, "카메라 초기 설정 완료")
            } /*else if let currentLocation = currentLocation {
                let cameraPosition = NMGLatLng(lat: currentLocation.latitude, lng: currentLocation.longitude)
                let camera = NMFCameraPosition(cameraPosition, zoom: 16.0)
                let cameraUpdate = NMFCameraUpdate(position: camera)
                uiView.moveCamera(cameraUpdate)
                context.coordinator.isInitialLocationSet = true
                Logger.shared.log(level: .debug, category: .ui, "카메라 초기 설정 완료")
            }*/
            
        }
        
        // 선택 마커 & 원
        if let sel = selectedLocation {
            context.coordinator.updateSelectedMarker(location: sel, mapView: uiView)
            context.coordinator.updateCircle(center: sel, radius: circleRadius, mapView: uiView)
        } else {
            context.coordinator.clearSelected()
        }
        
        
        // 현재 위치 마커
        if let cur = currentLocation {
            context.coordinator.updateCurrentMarker(location: cur, mapView: uiView)
        } else {
            context.coordinator.clearCurrent()
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator()
    }
    
    class Coordinator: NSObject, NMFMapViewTouchDelegate {
        var mapView: NMFMapView?
        var onMapTap: ((CLLocationCoordinate2D) -> Void)?
        var isInitialLocationSet = false
        
        private var selectedMarker: NMFMarker?
        private var circle: NMFCircleOverlay?
        private var currentMarker: NMFMarker?
        
        func mapView(_ mapView: NMFMapView, didTapMap latlng: NMGLatLng, point: CGPoint) {
            let coordinate = CLLocationCoordinate2D(latitude: latlng.lat, longitude: latlng.lng)
            Logger.shared.log(level: .debug, category: .ui, "지도 터치: \(coordinate)")
            onMapTap?(coordinate)
        }
        
        func updateSelectedMarker(location: CLLocationCoordinate2D, mapView: NMFMapView) {
            selectedMarker?.mapView = nil
            let newMarker = NMFMarker()
            newMarker.position = NMGLatLng(lat: location.latitude, lng: location.longitude)
            newMarker.iconImage = NMF_MARKER_IMAGE_YELLOW
            newMarker.mapView = mapView
            
            if let assetIcon = createCustomMarkerFromAsset() {
                newMarker.iconImage = assetIcon
            } else {
                newMarker.iconImage = NMF_MARKER_IMAGE_YELLOW
            }
            selectedMarker = newMarker
            
            Logger.shared.log(level: .debug, category: .ui, "선택된 위치 마커 표시됨")
        }
        
        func updateCurrentMarker(location: CLLocationCoordinate2D, mapView: NMFMapView) {
            currentMarker?.mapView = nil
            let m = NMFMarker()
            m.position = NMGLatLng(lat: location.latitude, lng: location.longitude)
            m.iconImage = NMF_MARKER_IMAGE_BLUE
            m.mapView = mapView
            currentMarker = m
            
            Logger.shared.log(level: .debug, category: .ui, "현재 위치 마커 표시됨")
        }
        
        func updateCircle(center: CLLocationCoordinate2D, radius: Double, mapView: NMFMapView) {
            circle?.mapView = nil
            
            let newCircle = NMFCircleOverlay()
            newCircle.center = NMGLatLng(lat: center.latitude, lng: center.longitude)
            newCircle.radius = radius
            newCircle.fillColor = UIColor.lemon10
            newCircle.outlineColor = UIColor.lemon10
            newCircle.outlineWidth = 2.0
            newCircle.mapView = mapView
            
            circle = newCircle
            
            Logger.shared.log(level: .debug, category: .ui, "원형 오버레이 표시됨")
        }
        func clearSelected() {
            selectedMarker?.mapView = nil
            selectedMarker = nil
            circle?.mapView = nil
            circle = nil
        }
        
        func clearCurrent() {
            currentMarker?.mapView = nil
            currentMarker = nil
        }
        
        private func createCustomMarkerFromAsset() -> NMFOverlayImage? {
            guard let assetImage = UIImage(named: "Image/ic_marker_png") else {
                Logger.shared.log(level: .debug, category: .ui, "Assets에서 'Image/ic_marker_png' 이미지를 찾을 수 없음")
                return nil
            }
            
            return NMFOverlayImage(image: assetImage)
        }
    }
}
