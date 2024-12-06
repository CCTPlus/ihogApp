//
//  AnalyticEventParameter.swift
//  iHog
//
//  Created by Jay Wilson on 11/7/24.
//

enum AnalyticEventParameter: String {
  case numberOfShows
  case paywallSource
  case errorLevel
  case purchaseState
  case purchaseAmount
  case onboardingStep
}

enum PaywallSource: String {
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

enum ErrorLevel: String {
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

enum PurchaseState: String {
  case completed

  var analyticsLabel: String {
    switch self {
      case .completed:
        "completed"
    }
  }
}
