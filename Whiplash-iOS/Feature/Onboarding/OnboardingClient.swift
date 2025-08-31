//
//  OnboardingClient.swift
//  Whiplash-iOS
//
//  Created by 남경민 on 8/9/25.
//

import Foundation
import ComposableArchitecture

struct OnboardingClient {
    var hasSeen: @Sendable () -> Bool
    var setSeen: @Sendable (_ seen: Bool) -> Void
}

extension OnboardingClient: DependencyKey {
    static let liveValue = Self(
        hasSeen: {
            UserDefaults.standard.bool(forKey: "hasSeenOnboarding")
        },
        setSeen: { seen in
            UserDefaults.standard.set(seen, forKey: "hasSeenOnboarding")
        }
    )
}

extension DependencyValues {
    var onboardingClient: OnboardingClient {
        get { self[OnboardingClient.self] }
        set { self[OnboardingClient.self] = newValue }
    }
}
