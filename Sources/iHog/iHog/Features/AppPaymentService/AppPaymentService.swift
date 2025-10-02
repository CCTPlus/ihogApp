//
//  AppPaymentService.swift
//  iHog
//
//  Created by Jay Wilson on 10/1/25.
//

import Foundation
import OSLog
import RevenueCat

/// Determines when to show a paywall based on a trigger
@Observable
class AppPaymentService {
  var shouldShowPaywall = false

  private var customerInfo: CustomerInfo? = nil {
    didSet {
      determineIsPro()
      determineDateOriginallySubscribed()
    }
  }

  @ObservationIgnored
  var lastUsedTrigger: PaywallTrigger? = nil

  var isPro: Bool
  var dateOriginallySubscribed: Date? = nil

  init(
    shouldShowPaywall: Bool = false,
    customerInfo: CustomerInfo? = nil,
    lastUsedTrigger: PaywallTrigger? = nil,
    isPro: Bool = false
  ) {
    self.shouldShowPaywall = shouldShowPaywall
    self.customerInfo = customerInfo
    self.lastUsedTrigger = lastUsedTrigger
    self.isPro = isPro
  }

  func configure() {
    let handler: (RevenueCat.LogLevel, String) -> Void = { level, message in
      switch level {
        case .debug:
          Logger.purchases.debug("\(message)")
        case .verbose:
          Logger.purchases.trace("\(message)")
        case .info:
          Logger.purchases.info("\(message)")
        case .warn:
          Logger.purchases.warning("\(message)")
        case .error:
          Logger.purchases.error("\(message)")
      }
    }
    Purchases.logHandler = handler
    #if DEBUG
      Purchases.logLevel = .debug
    #else
      Purchases.logLevel = .error
    #endif
    Purchases.configure(withAPIKey: AppInfo.revenueCatKey)
    Task {
      for await newCustomerInfo in Purchases.shared.customerInfoStream {
        await MainActor.run {
          customerInfo = newCustomerInfo
          Logger.appPaymentService.info(
            """
            💸 Subscription status updated:
                IsPro: \(self.isPro, privacy: .public)
            """
          )
        }
      }
    }
  }

  func determineIsPro() {
    for entitlement in HogEntitlement.allCases {
      guard
        let isActive = customerInfo?.entitlements.active
          .contains(where: { $0.key == entitlement.rawValue })
      else {
        // Did not find entitlement on user
        continue
      }
      if isActive {
        isPro = true
        // TODO: Setup analytics to mark the person's entitlement property
        return
      }
    }
    isPro = false
  }

  func determineDateOriginallySubscribed() {
    // Entitlement.pro use the date of purchase for pro
    if let isPro = customerInfo?.entitlements.active
      .contains(
        where: { $0.key == HogEntitlement.pro.rawValue })
    {
      if isPro {
        self.dateOriginallySubscribed =
          customerInfo?
          .entitlements[HogEntitlement.pro.rawValue]?
          .originalPurchaseDate
      }
    }
    // Entitlement.puntPage use the date of purchase for puntPage
    if let puntPageUser = customerInfo?.entitlements.active
      .contains(
        where: { $0.key == HogEntitlement.puntPage.rawValue })
    {
      if puntPageUser {
        self.dateOriginallySubscribed =
          customerInfo?
          .entitlements[HogEntitlement.puntPage.rawValue]?
          .originalPurchaseDate
      }
    }
    // Entitlement.earlyAdopter use the original purchase for app
    if let earlyAdopter = customerInfo?.entitlements.active
      .contains(
        where: { $0.key == HogEntitlement.earlyAdopter.rawValue })
    {
      if earlyAdopter {
        self.dateOriginallySubscribed =
          customerInfo?
          .entitlements[HogEntitlement.earlyAdopter.rawValue]?
          .originalPurchaseDate
      }
    }

    self.dateOriginallySubscribed = nil
  }

  func triggerPaywall(for trigger: PaywallTrigger) {
    guard isPro == false else {
      shouldShowPaywall = false
      return
    }
    self.lastUsedTrigger = trigger
    switch trigger {
      case .addShow(let showCount):
        // Want true to show paywall
        // Want to show paywall when a non-pro user has more than 1 show.
        // So any showcount > 0 should trigger the paywall
        shouldShowPaywall = showCount > 0
      case .thisIsAdamsFault, .customIcons, .userRequest, .puntPage:
        shouldShowPaywall = true
    }
  }
}
