//
//  AnalyticsEvent.swift
//  iHog
//
//  Created by Jay Wilson on 11/7/24.
//

/// Events tracked by analtyics
enum AnalyticEvent: String {
  case appLaunched
  case subscribeButtonTapped
  case error
  case purchase
  case connectToConsoleTapped
  case disconnectFromConsoleTapped
  case onboardingSkipTapped
  case onboardingStepViewed
}
