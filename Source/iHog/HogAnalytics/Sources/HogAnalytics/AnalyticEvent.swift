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

/// Events tracked by analtyics
public enum AnalyticEvent: String, Sendable {
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
  /// Error occured
  case error = "TelemetryDeck.Error.occurred"
}
