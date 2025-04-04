//
// -----------------------------------------------------------
// Project: iHog
// Created on 4/3/25 by @HeyJayWilson
// -----------------------------------------------------------
// Find HeyJayWilson on the web:
// 🕸️ Website             https://heyjaywilson.com
// 💻 Follow on GitHub:   https://github.com/heyjaywilson
// 🧵 Follow on Threads:  https://threads.net/@heyjaywilson
// 💭 Follow on Mastodon: https://iosdev.space/@heyjaywilson
// ☕ Buy me a ko-fi:     https://ko-fi.com/heyjaywilson
// -----------------------------------------------------------
// Copyright© 2025 CCT Plus LLC. All rights reserved.
//

import Foundation

enum UserProperty: String, Sendable {
  case isSandboxed
  case isDev
}

public enum AnalyticEventParameter: String, Sendable {
  case numberOfShows
  case paywallSource
  case errorLevel
  case purchaseState
  case purchaseAmount
  case onboardingStep
  case userIsSandBoxed = "user.isSandboxed"
  case featureFlagValue = "featureFlag.value"
  case featureFlagKey = "featureFlag.key"
  case logCategory
  case error
}

enum PaywallSource: String, Sendable {
  case settings
  case learnMore
  case addIconView
  case newShowView
  case puntPage
  case onboarding
  /// Only used in Xcode. If this pops up in non test mode there's a massive issue
  case preview

  var analyticsLabel: String {
    switch self {
      case .settings:
        return "Settings"
      case .learnMore:
        return "Learn More"
      case .addIconView:
        return "Add Icon View"
      case .newShowView:
        return "New Show View"
      case .puntPage:
        return "Punt Page"
      case .onboarding:
        return "Onboarding"
      case .preview:
        return "Xcode Preview"
    }
  }
}

public enum ErrorLevel: String, Sendable {
  case critical
  case fatal
  case warning

  var analyticsLabel: String {
    switch self {
      case .fatal:
        "fatal"
      case .critical:
        "critical"
      case .warning:
        "warn"
    }
  }
}

public enum PurchaseState: String, Sendable {
  case completed

  var analyticsLabel: String {
    switch self {
      case .completed:
        "completed"
    }
  }
}
