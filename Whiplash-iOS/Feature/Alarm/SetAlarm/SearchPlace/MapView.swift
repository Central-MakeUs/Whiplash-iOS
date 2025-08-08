//
//  MapView.swift
//  Whiplash-iOS
//
//  Created by 남경민 on 8/4/25.
//

import SwiftUI
import ComposableArchitecture
import NMapsMap
import CoreLocation

struct MapView: View {
    @Bindable var store: StoreOf<MapFeature>
    
    var body: some View {
        ZStack {
            // 네이버 맵
            NaverMapView(
                currentLocation: store.currentLocation,
                circleRadius: store.circleRadius,
                onMapTap: { coordinate in
                    //store.send(.mapTapped(coordinate))
                }
            )
            .ignoresSafeArea()
            .background(Color.black)
            
            VStack(spacing: 0) {
                Spacer()
                
                // 위치 상태 표시
                if store.currentLocation == nil {
                    VStack {
                        Text("위치 정보를 가져오는 중...")
                            .foregroundColor(.white)
                            .padding()
                            .background(Color.black.opacity(0.7))
                            .cornerRadius(8)
                    }
                    .padding()
                }
                
                Spacer()
            
            }
            
            AppBottomSheet(isPresented: $store.isRegistrationSheetPresented.sending(\.registrationSheet)) {
                RegisterPlaceSheet(
                    title: store.place.name,
                    message: store.place.address,
                    onRegister: {},
                    onCancel: {})
            }
        }
        .background(Color.black)
        .onAppear {
            store.send(.onAppear)
        }
        .preferredColorScheme(.dark)
    }
}

struct NaverMapView: UIViewRepresentable {
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
        
        // 카메라 설정 (초기에만)
        if !context.coordinator.isInitialLocationSet {
            let cameraPosition = NMGLatLng(lat: location.latitude, lng: location.longitude)
            let camera = NMFCameraPosition(cameraPosition, zoom: 16.0)
            let cameraUpdate = NMFCameraUpdate(position: camera)
            uiView.moveCamera(cameraUpdate)
            context.coordinator.isInitialLocationSet = true
            Logger.shared.log(level: .debug, category: .ui, "카메라 초기 설정 완료")
        }
        
        // 마커 표시
        context.coordinator.updateMarker(location: location, mapView: uiView)
        
        // 원형 오버레이 표시
        context.coordinator.updateCircle(center: location, radius: circleRadius, mapView: uiView)
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator()
    }
    
    class Coordinator: NSObject, NMFMapViewTouchDelegate {
        var mapView: NMFMapView?
        var onMapTap: ((CLLocationCoordinate2D) -> Void)?
        var isInitialLocationSet = false
        private var marker: NMFMarker?
        private var circle: NMFCircleOverlay?
        
        func mapView(_ mapView: NMFMapView, didTapMap latlng: NMGLatLng, point: CGPoint) {
            let coordinate = CLLocationCoordinate2D(latitude: latlng.lat, longitude: latlng.lng)
            Logger.shared.log(level: .debug, category: .ui, "지도 터치: \(coordinate)")
            onMapTap?(coordinate)
        }
        
        func updateMarker(location: CLLocationCoordinate2D, mapView: NMFMapView) {
            marker?.mapView = nil
            
            let newMarker = NMFMarker()
            newMarker.position = NMGLatLng(lat: location.latitude, lng: location.longitude)
            newMarker.iconImage = NMF_MARKER_IMAGE_YELLOW
            newMarker.mapView = mapView
            
            
            if let assetIcon = createCustomMarkerFromAsset() {
                newMarker.iconImage = assetIcon
            } else {
                newMarker.iconImage = NMF_MARKER_IMAGE_YELLOW
            }
            marker = newMarker
            
            Logger.shared.log(level: .debug, category: .ui, "마커 표시됨")
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
        
        private func createCustomMarkerFromAsset() -> NMFOverlayImage? {
            guard let assetImage = UIImage(named: "Image/ic_marker_png") else {
                Logger.shared.log(level: .debug, category: .ui, "Assets에서 'Image/ic_marker_png' 이미지를 찾을 수 없음")
                return nil
            }
            
            return NMFOverlayImage(image: assetImage)
        }
    }
}

struct PlaceRegistrationSheet: View {
    @State private var placeName = ""
    let onRegister: (String) -> Void
    let onCancel: () -> Void
    
    var body: some View {
        NavigationView {
            VStack(spacing: 24) {
                Text("목표 장소 등록")
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(.white)
                    .padding(.top, 20)
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("장소명")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.gray)
                    
                    TextField("장소명을 입력하세요", text: $placeName)
                        .font(.system(size: 16))
                        .padding(.vertical, 14)
                        .padding(.horizontal, 16)
                        .background(
                            RoundedRectangle(cornerRadius: 8)
                                .fill(Color(.systemGray6))
                        )
                        .foregroundColor(.primary)
                }
                
                Button(action: {
                    guard !placeName.isEmpty else { return }
                    onRegister(placeName)
                }) {
                    Text("등록")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(
                            RoundedRectangle(cornerRadius: 8)
                                .fill(placeName.isEmpty ? Color.gray : Color.blue)
                        )
                }
                .disabled(placeName.isEmpty)
                
                Spacer()
            }
            .padding(.horizontal, 20)
            .background(Color(.systemBackground))
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(
                leading: Button("취소") {
                    onCancel()
                }
                    .foregroundColor(.blue)
            )
        }
        .preferredColorScheme(.dark)
    }
}

#Preview {
    MapView(
        store: Store(initialState: MapFeature.State()) {
            MapFeature()
        }
    )
}
