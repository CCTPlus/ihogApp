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

import HogData
import HogUtilities
import StoreKit  // Used for purchase tracking
import TelemetryDeck

/// Handles analytics tracking and reporting for the iHog app.
/// This class is isolated to the main actor to prevent data races when
/// logging events and managing user identification.
public struct HogAnalytics: Sendable {
  /// The TelemetryDeck API key used for analytics
  static private let telemetryDeckKey = "63666D7A-FE6E-4509-B166-A00FF4A7171C"

  /// Default initializer for environment's defaultValue
  public init() {
    let config = TelemetryDeck.Config(appID: Self.telemetryDeckKey)
    TelemetryDeck.initialize(config: config)
  }

  /// Updates the user identifier for analytics tracking
  /// - Parameter userID: The ID to identify this user in analytics
  public func identifyUser(with userID: String) {
    TelemetryDeck.updateDefaultUserID(to: userID)
  }

  /// Logs an analytics event with optional parameters
  /// - Parameters:
  ///   - event: The event to log
  ///   - parameters: Optional parameters to include with the event
  public func logEvent(
    with event: AnalyticEvent,
    parameters: [AnalyticEventParameter: Any] = [:],
    showRepository: ShowRepository
  ) async {
    var analyticParameters = parameters
    if let shows = try? await showRepository.fetchShows() {
      analyticParameters[.numberOfShows] = shows.count
    }
    let stringParameters = processParameters(parameters: analyticParameters)
    TelemetryDeck.signal(event.rawValue, parameters: stringParameters)

    HogLogger.log(category: .analytics)
      .debug("🔦 Logged event: \(event.rawValue) | \(stringParameters)")
  }

  func processParameters(parameters: [AnalyticEventParameter: Any]) -> [String: String] {
    let stringParameters = parameters.reduce(into: [String: String]()) { result, pair in
      let value = pair.value
      if let rawValueEnum = value as? any RawRepresentable<String> {
        result[pair.key.rawValue] = rawValueEnum.rawValue
      } else {
        result[pair.key.rawValue] = String(describing: value)
      }
    }
    return stringParameters
  }

  public func logError(
    with error: Error,
    for logCatergory: LogCategory,
    level: ErrorLevel
  ) {
    var eventParameters: [AnalyticEventParameter: Any] = [
      .errorLevel: level.analyticsLabel,
      .logCategory: logCatergory.rawValue,
    ]

    if let identifiableError = error as? IdentifiableError {
      let stringParameters = processParameters(parameters: eventParameters)
      // Use simplified error logging for IdentifiableError
      TelemetryDeck
        .errorOccurred(
          identifiableError: identifiableError,
          parameters: stringParameters
        )
    } else {
      eventParameters[.error] = error.localizedDescription
      let stringParameters = processParameters(parameters: eventParameters)
      // Use full syntax for other errors
      TelemetryDeck
        .signal(AnalyticEvent.error.rawValue, parameters: stringParameters)
    }

    // Keep existing logging
    HogLogger
      .log(category: logCatergory)
      .error("🚨 Error: \(error) level: \(level.analyticsLabel)")
  }

  public func logPurchase(transaction: Transaction) {
    TelemetryDeck.purchaseCompleted(transaction: transaction)
  }

}
