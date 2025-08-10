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
            AppSearchBar(text: $store.query.sending(\.queryChanged),
                         placeholder: "도착 목표 장소는?",
                         onClear: { store.send(.clear) }
            )
            
            if store.isLoading {
                ProgressView()
                    .padding()
            }
            
            if !store.results.isEmpty {
                List {
                    ForEach(store.results, id: \ .self) { place in
                        Button {
                            store.send(.selectPlace(place))
                        } label: {
                            HStack {
                                Text(place.name)
                                    .foregroundColor(.white)
                                Spacer()
                            }
                        }
                        .listRowBackground(Color.gray900)
                    }
                }
                .listStyle(.plain)
                .background(Color.gray900)
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
