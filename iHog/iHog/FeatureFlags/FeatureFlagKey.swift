//
//  FeatureFlag.swift
//  iHog
//
//  Created by Jay Wilson on 11/10/24.
//

/// Feature flag keys defined in PostHog
enum FeatureFlagKey: String, CaseIterable, Identifiable {
  // Enables the use of SwiftData instead of CoreData in the app
  case swiftdata
}

extension FeatureFlagKey {
  var id: String { rawValue }

  var listLabel: String {
    switch self {
      case .swiftdata:
        "Replace data storage with Swift Data"
    }
  }

  var isAvailable: Bool {
    switch self {
      case .swiftdata:
        false
    }
  }
}
