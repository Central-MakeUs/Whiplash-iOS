//
//  SearchPlaceView.swift
//  Whiplash-iOS
//
//  Created by 남경민 on 8/3/25.
//

// PlaceSearchView.swift

import SwiftUI
import ComposableArchitecture

struct SearchPlaceView: View {
    @Bindable var store: StoreOf<SearchPlaceFeature>
    
    var body: some View {
        VStack {
            
            Spacer().frame(height: 32)
            
            AppSearchBar(text: $store.query.sending(\.queryChanged),
                         placeholder: "도착 목표 장소는?",
                         onClear: { store.send(.clear) }
            )
            
            if store.isLoading {
                ProgressView()
                    .padding()
            }
            
            if !store.places.isEmpty {
                ScrollView {
                    LazyVStack(spacing: 0) {
                        ForEach(store.places) { place in
                            HStack {
                                VStack(alignment: .leading, spacing: 4) {
                                    AppText(text: place.name,
                                            style: .body1_m_16,
                                            color: .white)
                                    AppText(text: place.address,
                                            style: .body2_m_14,
                                            color: .gray500)
                                }
                                Spacer()
                            }
                            .contentShape(Rectangle())
                            .onTapGesture { store.send(.selectPlace(place)) }
                            .padding(.vertical, 16)
                            .background(Color.gray900)
                            
                            Divider().background(Color.gray800)
                        }
                    }
                    .padding(.horizontal, 4)
                }
                
            } else if !store.query.isEmpty && !store.isLoading {
                VStack {
                    Text("검색 결과가 없습니다.")
                        .foregroundColor(.gray500)
                        .padding()
                    Spacer()
                }
            } else {
                Spacer()
            }
            
        }
        .padding(.horizontal, AppLayout.horizontalPadding)
        .customNavigationBar(
            leftView: {
                Button {
                    store.send(.backButtonTapped)
                } label: {
                    Image(.Image.icLeftArrowBlack28)
                }
            },
            centerView: {
                AppText(text: "장소 선택",
                        style: .subtitle5_b_16,
                        color: .gray50)
            }
        )
        .background(Color.gray900.edgesIgnoringSafeArea(.all))
    }
    
}

#Preview {
    SearchPlaceView(
        store: Store(initialState: SearchPlaceFeature.State()) {
            SearchPlaceFeature()
        }
    )
}
