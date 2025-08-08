//
//  AutoLoginClient.swift
//  Whiplash-iOS
//
//  Created by 남경민 on 8/9/25.
//

import Foundation
import ComposableArchitecture

struct AutoLoginClient {
  var isEnabled: @Sendable () -> Bool
  var setEnabled: @Sendable (_ on: Bool) -> Void

  var clearAll: @Sendable () -> Void
}

extension AutoLoginClient: DependencyKey {
  static let liveValue: Self = {
    let defaults = UserDefaults.standard
    let enabled = "autoLogin.enabled"

    return .init(
      isEnabled: { defaults.bool(forKey: enabled) },
      setEnabled: { defaults.set($0, forKey: enabled) },
      clearAll: {
        defaults.removeObject(forKey: enabled)
      }
    )
  }()
}
