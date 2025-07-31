//
//  DependencyValues.swift
//  Whiplash-iOS
//
//  Created by 남경민 on 8/1/25.
//

import Foundation
import ComposableArchitecture

extension DependencyValues {
    
    var authUsecase: AuthUseCase {
        get { self[AuthUseCase.self] }
        set { self[AuthUseCase.self] = newValue }
    }
    
    var appleRepository: AppleAuthRepositoryImpl {
        get { self[AppleAuthRepositoryImpl.self] }
        set { self[AppleAuthRepositoryImpl.self] = newValue }
    }
    
    var kakaoRepository: KakaoAuthRepositoryImpl {
        get { self[KakaoAuthRepositoryImpl.self] }
        set { self[KakaoAuthRepositoryImpl.self] = newValue }
    }
}
