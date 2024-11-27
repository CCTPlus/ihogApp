//
//  AnalyticsEvent.swift
//  iHog
//
//  Created by Jay Wilson on 11/7/24.
//

/// Events tracked by analtyics
public enum AnalyticEvent: String {
  case appLaunched
  case addShowButtonTapped
  case showCreated
  case showSelected
  case subscribeButtonTapped
  case error
  case purchase
  case connectToConsoleTapped
  case disconnectFromConsoleTapped
  case tabBarCollapsed
  case tabBarExpanded
  case tabTapped
}
