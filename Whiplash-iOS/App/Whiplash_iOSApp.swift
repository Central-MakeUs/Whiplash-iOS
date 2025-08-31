//
//  Whiplash_iOSApp.swift
//  Whiplash-iOS
//
//  Created by 남경민 on 6/24/25.
//

import SwiftUI
import ComposableArchitecture

@main
struct Whiplash_iOSApp: App {
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @State var appStore = Store(
        initialState: RootFeature.State(), reducer: {
            RootFeature()
        })
    
    init() {
        let store = appStore
        let delegate = appDelegate
        
        DispatchQueue.main.async {
            delegate.rootStore = store
            print("AppDelegate에 RootStore 참조 설정 완료 (Method 2)")
        }
    }
    
    var body: some Scene {
        WindowGroup {
            
            RootView(store: appStore)
            
            
            /*
             MapView(store: Store(initialState: MapFeature.State()) {MapFeature() })*/
            /*
            PlaceSearchView(
                store: Store(initialState: SearchLocationFeature.State()) {
                    SearchLocationFeature()
                }
            )*/
            /*
            HomeView(store: Store(initialState: HomeFeature.State(),
                                   reducer: { HomeFeature() })
            )*/
            /*
            LoginView(store: Store(initialState: LoginFeature.State(), reducer: { LoginFeature() }))
                .onOpenURL { url in
                    _ = AppURLRouter.route(url)
                }*/
        }
    }
}
