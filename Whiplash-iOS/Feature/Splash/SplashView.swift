//
//  SplashView.swift
//  Whiplash-iOS
//
//  Created by 남경민 on 8/9/25.
//

import SwiftUI
import ComposableArchitecture

struct SplashView: View {
    //@Bindable var store: StoreOf<SearchLocationFeature>
    
    var body: some View {
        ZStack {
            LinearGradient(
                stops: [
                    Gradient.Stop(color: Color(red: 0.16, green: 0.16, blue: 0.16), location: 0.00),
                    Gradient.Stop(color: .black, location: 1.00),
                ],
                startPoint: UnitPoint(x: 0.5, y: 0.22),
                endPoint: UnitPoint(x: 0.5, y: 1)
            )
            
            Image(.Image.imgSplashLogo)
        }
        .ignoresSafeArea()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

#Preview {
    SplashView()
}
