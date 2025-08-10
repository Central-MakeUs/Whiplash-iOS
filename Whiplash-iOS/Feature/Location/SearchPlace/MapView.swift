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
    
    private var nav: NavigationConfig { store.mapStyle.navigationConfig }
    private var title: String { nav.title }
    private var dim: Bool { store.mapStyle.dim }
    private var sheetType: BottomSheetType { store.mapStyle.bottomSheetType }
    
    var body: some View {
        ZStack {
            NaverMapView(
                selectedLocation: store.selectedLocation,
                currentLocation: store.currentLocation,
                circleRadius: store.circleRadius,
                onMapTap: { coord in
                    store.send(.mapTapped(coord))
                }
            )
            .ignoresSafeArea()
            .background(Color.black)
            
            if dim { gradientDim }
            
            VStack(spacing: 0) {
                Spacer()
                
                // 위치 상태 표시
                if store.currentLocation == nil {
                    VStack {
                        ProgressView()
                    }
                    .padding()
                }
                
                Spacer()
                
            }
            // 바텀시트
            if sheetType != .none {
                AppBottomSheet(
                    isPresented: $store.isSheetPresented.sending(\.setSheetPresented)
                ) {
                    switch sheetType {
                    case .registerPlace:
                        RegisterPlaceSheet(
                            title: store.updatedPlace.name,
                            message: store.updatedPlace.address,
                            onRegister: { store.send(.registerPlace(store.mapStyle.place.name)) },
                            onCancel: { store.send(.setSheetPresented(false)) }
                        )
                    case .confirmRadius:
                        EmptyView()
                    case .none:
                        EmptyView()
                    }
                }
            }
        }
        .applyCustomNav(style: nav.style, title: title, back: {
            store.send(.backButtonTapped)
        })
        .background(Color.gray900)
        .onAppear {
            store.send(.onAppear)
        }
        .preferredColorScheme(.dark)
    }
    
    private var gradientDim: some View {
        Rectangle()
            .foregroundColor(.clear)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(
                LinearGradient(
                    stops: [
                        .init(color: .black.opacity(0.8), location: 0.00),
                        .init(color: .black.opacity(0),   location: 0.20),
                        .init(color: .black.opacity(0),   location: 0.80),
                        .init(color: .black.opacity(0.8), location: 1.00),
                    ],
                    startPoint: .top, endPoint: .bottom
                )
            )
    }
}

private extension View {
    func applyCustomNav(style: NavBarStyle, title: String, back: @escaping () -> Void) -> some View {
        switch style {
        case .leftCenter:
            return AnyView(
                self.customNavigationBar(
                    leftView: {
                        Button(action: back) { Image(.Image.icLeftArrowBlack28) }
                    },
                    centerView: {
                        AppText(text: title, style: .subtitle5_b_16, color: .gray50)
                    }
                )
            )
        case .center:
            return AnyView(
                self.customNavigationBar(
                    centerView: {
                        HStack {
                            Image(.Image.icMapPinFillGray22)
                            AppText(text: "위치", style: .subtitle5_b_16, color: .gray50)
                        }
                    }
                )
                .background(Color.clear)
            )
        case .hidden:
            return AnyView(self)
        }
    }
}


#Preview {
    MapView(
        store: Store(initialState: MapFeature.State(mapStyle: .sampleData)) {
            MapFeature()
        }
    )
}
