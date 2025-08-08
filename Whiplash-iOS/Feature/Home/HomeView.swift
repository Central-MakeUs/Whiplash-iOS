//
//  HomeView.swift
//  Whiplash-iOS
//
//  Created by 남경민 on 8/2/25.
//

import SwiftUI
import ComposableArchitecture

struct HomeView: View {
    @Bindable var store: StoreOf<HomeFeature>
    
    init(store: StoreOf<HomeFeature>) {
        self.store = store
    }
    
    var body: some View {
        ZStack {
            Color.gray900
                .ignoresSafeArea()
            VStack {
            }
            .customNavigationBar (
                leftView: {
                    AppText(text: "알람 목록", style: .subtitle5_b_16, color: .white)
                },
                rightView: {
                    HStack(spacing: 8) {
                        Button {
                            
                        } label: {
                            Image(.Image.icPius28)
                        }
                        
                        Button {
                            
                        } label: {
                            Image(.Image.icDot28)
                        }
                    }
                }
            )
        }
        .onAppear {
            store.send(.onAppear)
        }
    }
}

#Preview {
    HomeView(store: Store(initialState: HomeFeature.State(),
                           reducer: { HomeFeature() })
    )
}
