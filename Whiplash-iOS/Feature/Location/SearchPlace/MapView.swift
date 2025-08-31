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
    @State var h: CGFloat = 232
    
    private var nav: NavigationConfig { store.mapStyle.navigationConfig }
    private var title: String { nav.title }
    private var dim: Bool { store.mapStyle.dim }
    
    @Environment(\.scenePhase) private var scenePhase
    @State private var vibrator = ContinuousVibrator()
    
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
            if store.mapStyle.bottomSheetType == .ringAlarm {
                
                RingAlarmView(remainingTime: 0,
                              onVerify: {store.send(.changeBottomSheetType(.verifyLocation))},
                              onOffOnce: {store.send(.changeBottomSheetType(.confirmInactive))})
                
            } else {
                // 바텀시트
                if store.mapStyle.bottomSheetType != .none {
                    AppBottomSheet(
                        isPresented: $store.isSheetPresented.sending(\.setSheetPresented),
                        snapHeights: $store.bottomSheetHeight.sending(\.setBottomSheetHeight)
                    ) {
                        switch store.mapStyle.bottomSheetType {
                        case .registerPlace:
                            RegisterPlaceSheet(
                                title: store.updatedPlace.name,
                                message: store.updatedPlace.address,
                                onRegister: { store.send(.registerPlace) },
                                onCancel: { store.send(.backButtonTapped) }
                            )
                        case .ringAlarm:
                            EmptyView()
                        case .confirmInactive:
                            ConfirmInactiveSheet(
                                remaining: store.remainingOffCount,
                                onUse: { store.send(.alarmOffButtonTapped) },
                                onCancel: {  }
                            )
                        case .cantUseInactive:
                            CannotUseInactiveSheet(
                                remaining: store.remainingOffCount,
                                onMoveToRegister: {
                                    store.send(.changeBottomSheetType(.verifyLocation))
                                })
                        case .verifyLocation:
                            VerifyLocationSheet(
                                onConfirm: {
                                    store.send(.startVerification)
                                },
                                onCancel:  {
                                    store.send(.backButtonTapped)
                                }
                            )
                        case .verifyingLocation:
                            VerifyingSheet()
                        case .cantVerifyLocation:
                            CannotTurnOffSheet(
                                onRetry:  {
                                    store.send(.startVerification)
                                },
                                onCancel: {
                                    store.send(.backButtonTapped)
                                },
                                distanceText: "100m"
                            )
                        case .none:
                            EmptyView()
                        }
                    }
                }
            }
            
            if store.showSuccessView {
                SuccessView(store: store)
                    .transition(.move(edge: .bottom).combined(with: .opacity))
                    .animation(.spring(response: 0.6, dampingFraction: 0.8), value: store.showSuccessView)
            }
        }
        .applyCustomNav(style: nav.style,
                        title: title,
                        back: {
            store.send(.backButtonTapped)
        })
        .background(Color.gray900)
        .onAppear {
            store.send(.onAppear)
        }
        .preferredColorScheme(.dark)
        .onAppear {
            store.send(.updateHeight(store.mapStyle.bottomSheetType))
        }
        .onChange(of: store.mapStyle.bottomSheetType) { oldValue, newValue in
            store.send(.updateHeight(store.mapStyle.bottomSheetType))
        }
        .onAppear {
            if store.mapStyle.bottomSheetType == .ringAlarm {
                vibrator?.startLoop(intensity: 1.0, sharpness: 0.6, segment: 4.0) // 포그라운드 지속 진동 시작
            }
        }

        .onChange(of: scenePhase) { phase in
            if store.mapStyle.bottomSheetType == .ringAlarm {
                switch phase {
                case .active:
                    if vibrator?.isRunning == false { vibrator?.startLoop() } // 포그라운드 복귀 시 재개
                case .background, .inactive:
                    vibrator?.stop() // 백그라운드로 내려가면 반드시 정지(시스템이 허용 안 함)
                @unknown default: break
                }
            }
        }
        .onDisappear {
            vibrator?.stop()
        }
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
    func applyCustomNav(style: NavBarStyle,
                        title: String,
                        back: @escaping () -> Void) -> some View {
        switch style {
        case .leftCenter:
            return AnyView(
                self.customNavigationBar(
                    leftView: {
                        Button(action: back) { Image(.Image.icLeftArrowBlack28) }
                    },
                    centerView: {
                        AppText(text: title,
                                style: .subtitle5_b_16,
                                color: .gray50)
                    }
                )
            )
        case .center:
            return AnyView(
                self.customNavigationBar(
                    centerView: {
                        HStack {
                            Image(.Image.icMapPinFillGray22)
                            AppText(text: "위치",
                                    style: .subtitle5_b_16,
                                    color: .gray50)
                        }
                    }
                    
                )
                .background(Color.clear)
                .ignoresSafeArea()
            )
        case .hidden:
            return AnyView(self)
        }
    }
}


#Preview {
    MapView(
        store: Store(initialState: MapFeature.State(mapStyle: .sampleData2)) {
            MapFeature()
        }
    )
}
