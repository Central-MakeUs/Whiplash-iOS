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
    
    var googleRepository: GoogleAuthRepositoryImpl {
        get { self[GoogleAuthRepositoryImpl.self] }
        set { self[GoogleAuthRepositoryImpl.self] = newValue }
    }
    
    var placeRepository: PlaceRepositoryImpl {
        get { self[PlaceRepositoryImpl.self] }
        set { self[PlaceRepositoryImpl.self] = newValue }
    }
    
    var alarmRepository: AlarmRepositoryImpl {
        get { self[AlarmRepositoryImpl.self] }
        set { self[AlarmRepositoryImpl.self] = newValue }
    }
    
    var locationClient: LocationClient {
        get { self[LocationClient.self] }
        set { self[LocationClient.self] = newValue }
    }
    
    var autoLoginClient: AutoLoginClient {
        get { self[AutoLoginClient.self] }
        set { self[AutoLoginClient.self] = newValue }
    }
}
