//
//  SearchPlaceView.swift
//  Whiplash-iOS
//
//  Created by 남경민 on 8/3/25.
//

// PlaceSearchView.swift

import SwiftUI

struct PlaceSearchView: View {
    @Binding var selectedText: String
    @State private var searchText: String = ""

    var body: some View {
        VStack {
            AppSearchBar(text: $searchText,
                         placeholder: "도착 목표 장소는?")

            List {
                ForEach(searchResults, id: \.self) { place in
                    Button(place) {
                        selectedText = place
                        // 화면 닫기 (presenting 방식에 따라 dismiss 구현 필요)
                    }
                }
            }
        }
        .background(Color.gray900.edgesIgnoringSafeArea(.all))
    }

    var searchResults: [String] {
        if searchText.isEmpty { return [] }
        return ["구리시 갈매동", "구리시 도촌길", "구리시 갈매길"].filter { $0.contains(searchText) }
    }
}

