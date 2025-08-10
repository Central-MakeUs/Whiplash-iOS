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
            if store.cards.isEmpty {
                AlarmEmptyView()
            } else {
                ScrollView {
                    LazyVStack(spacing: 12) {
                        ForEach(store.scope(state: \.cards, action: \.card)) { cardStore in
                            AlarmCardView(store: cardStore)
                        }
                    }
                    .padding(.top, 12)
                    .padding(.horizontal, 16)
                }
            }
        }
        .ignoresSafeArea()
        .customNavigationBar (
            leftView: {
                AppText(text: "알람 목록", style: .subtitle5_b_16, color: .white)
            },
            rightView: {
                HStack(spacing: 8) {
                    Button {
                        store.send(.addButtonTapped)
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
        .background {
            Color.gray900
        }
        .onAppear {
            store.send(.onAppear)
        }
    }
}

struct AlarmEmptyView: View {
    
    var body: some View {
        VStack {
            Spacer()
            Image(.Image.imgEmpty120)
                .resizable()
                .scaledToFit()
                .frame(width: 120, height: 120)
            
            Spacer().frame(height: 24)
            
            AppText(
                text: "아직 알람이 없어요",
                style: .subtitle4_m_18,
                color: .white
            )
            
            Spacer().frame(height: 4)
            
            AppText(
                text: "우측 상단의 +버튼으로",
                style: .body2_m_14,
                color: .gray400
            )
            AppText(
                text: "알람을 추가해 보세요",
                style: .body2_m_14,
                color: .gray400
            )
            Spacer()
        }
        .frame(maxWidth: .infinity)
        .padding(.horizontal, 16)
    }
}



#Preview {
    HomeView(store: Store(initialState: HomeFeature.State(),
                          reducer: { HomeFeature() })
    )
}
