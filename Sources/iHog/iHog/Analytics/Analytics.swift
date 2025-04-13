//
//  Analytics.swift
//  iHog
//
//  Created by Jay Wilson on 11/7/24.
//

import CoreData
import PostHog
import StoreKit  // I don't like this but it's necessary for logging strekit transactions
import TelemetryDeck

class Analytics {
  // Analytics should only be initialized one time so a signleton it is!
  static let shared = Analytics()

  private let telemetryDeckAppID = "63666D7A-FE6E-4509-B166-A00FF4A7171C"
  private var userID = ""

  init() {
    let config = TelemetryDeck.Config(appID: telemetryDeckAppID)
    TelemetryDeck.initialize(config: config)

    // Setup posthog for analytics and feature flags
    // Deciding between telemetry deck and posthog, so why not have both for the time being?
    let POSTHOG_API_KEY = "phc_VQu7iGYwqrPQW2v2gTH0xalbGruE4iye6zmp2M4Iep2"
    // usually 'https://us.i.posthog.com' or 'https://eu.i.posthog.com'
    let POSTHOG_HOST = "https://us.i.posthog.com"

    let postHogConfig = PostHogConfig(apiKey: POSTHOG_API_KEY, host: POSTHOG_HOST)
    PostHogSDK.shared.setup(postHogConfig)
  }

  func identifyUser(with userID: String) {
    self.userID = userID
    TelemetryDeck.updateDefaultUserID(to: userID)
    PostHogSDK.shared.identify(userID)
  }

  private func getNumberOfShows() async -> Int {
    let backgroundContext = PersistenceController.shared.container.newBackgroundContext()
    let numberOfShows: Int? = try? await backgroundContext.perform {
      let fetchRequest: NSFetchRequest<CDShowEntity> = CDShowEntity.fetchRequest()
      let count = try backgroundContext.count(for: fetchRequest)
      return count
    }
    return numberOfShows ?? 0
  }

  func logEvent(with event: AnalyticEvent, parameters: [AnalyticEventParameter: Any] = [:]) {
    // Make sure the user has the right user ID
    identifyUser(with: userID)
    Task {
      var parameters = parameters
      parameters[.numberOfShows] = await getNumberOfShows()
      parameters[.userIsSandBoxed] = AppInfo.isSandboxed

      // Convert to [String: String] for TelemetryDeck
      let stringParameters = parameters.reduce(into: [String: String]()) { result, pair in
        let value = pair.value
        if let rawValueEnum = value as? any RawRepresentable<String> {
          result[pair.key.rawValue] = rawValueEnum.rawValue
        } else {
          result[pair.key.rawValue] = String(describing: value)
        }
      }

      // Convert to [String: Any] for PostHog
      let anyParameters = parameters.reduce(into: [String: Any]()) { result, pair in
        let value = pair.value
        if let rawValueEnum = value as? any RawRepresentable<String> {
          result[pair.key.rawValue] = rawValueEnum.rawValue
        } else {
          result[pair.key.rawValue] = value
        }
      }

      TelemetryDeck.signal(event.rawValue, parameters: stringParameters)
      await MainActor.run {
        PostHogSDK.shared.capture(
          event.rawValue,
          properties: anyParameters
        )
      }
      HogLogger.log(category: .analytics)
        .debug("🔦 Logged event: \(event.rawValue) | \(stringParameters)")
    }
  }

  func logError(with error: Error, for logCategory: LogCategory, level: ErrorLevel) {
    HogLogger.log(category: logCategory).error("🚨 Error: \(error)")
    TelemetryDeck.signal(
      "iHog.Error.occurred",
      parameters: ["iHog.Error.id": error.localizedDescription]
    )
    if let error = error as? IdentifiableError {
      TelemetryDeck
        .errorOccurred(
          identifiableError: error,
          parameters: [
            "error.level": level.rawValue,
            "error.category": logCategory.rawValue,
          ]
        )
    } else {
      TelemetryDeck
        .errorOccurred(
          id: logCategory.rawValue,
          message: error.localizedDescription,
          parameters: [
            "error.level": level.rawValue,
            "error.category": logCategory.rawValue,
          ]
        )
    }
  }

  func logPurchase(transacion: Transaction) {
    TelemetryDeck.purchaseCompleted(transaction: transacion)
    let amount = transacion.price ?? 0
    PostHogSDK.shared.capture(
      AnalyticEvent.purchase.rawValue,
      properties: [
        AnalyticEventParameter.purchaseState.rawValue: PurchaseState.completed.analyticsLabel,
        AnalyticEventParameter.purchaseAmount.rawValue: amount,
      ]
    )
  }

  func logAnalyticsCodes(_ codes: [String]) {
    TelemetryDeck.signal(
      "UserProperties.\(AnalyticEvent.userCodeLoaded.rawValue)",
      parameters: ["userCodes": String(describing: codes)]
    )
    PostHogSDK.shared.capture(
      AnalyticEvent.userCodeLoaded.rawValue,
      userProperties: ["userCodes": codes]
    )
    HogLogger.log(category: .analytics)
      .debug("🔦 Logged event: \(AnalyticEvent.userCodeLoaded.rawValue) | \(codes)")
  }

  func logFeatureFlagToggle(flag: FeatureFlagKey, value: Bool) {
    logEvent(
      with: .featureFlagToggled,
      parameters: [
        .featureFlagKey: flag.rawValue,
        .featureFlagValue: value,
      ]
    )
  }
}
