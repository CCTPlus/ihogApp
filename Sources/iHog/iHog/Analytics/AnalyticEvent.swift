//
//  AnalyticsEvent.swift
//  iHog
//
//  Created by Jay Wilson on 11/7/24.
//

/// Events tracked by analtyics
enum AnalyticEvent: String {
  /// Track when the app is launched
  case appLaunched
  /// Track when the subscribe button is tapped
  case subscribeButtonTapped
  /// Track when a purchase is made
  case purchase
  /// Track when the connect to console button is tapped
  case connectToConsoleTapped
  /// Track when the disconnect from console button is tapped
  case disconnectFromConsoleTapped
  /// Track when the onboarding skip button is tapped to determine if it's useful. More skips means less useful to users
  case onboardingSkipTapped
  /// Track when the onboarding step is viewed so that we can see how many steps are completed
  case onboardingStepViewed
  /// Track when the user profile is tapped
  case userProfileTapped
  /// Track when the user code is loaded
  case userCodeLoaded
  /// Track when a feature flag is toggled
  case featureFlagToggled
  /// Show was actually deleted
  case showDeleted
  /// Button to delete show was tapped
  case showDeleteTapped
    /// Add show button tapped
case addShowTapped

  /// Hyphen separated
  var value: String {
    switch self {
      default:
        String(describing: self)
          .replacingOccurrences(of: "([A-Z])", with: "-$1", options: .regularExpression)
          .lowercased()
    }
  }
}
