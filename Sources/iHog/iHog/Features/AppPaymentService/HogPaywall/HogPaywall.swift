//
//  HogPaywall.swift
//  iHog
//
//  Created by Jay Wilson on 10/1/25.
//

import RevenueCat
import RevenueCatUI
import SwiftUI

struct HogPaywallView: View {
  @Environment(AppPaymentService.self) var appPaymentService

  var showDismiss: Bool
  var source: PaywallSource

  var body: some View {
    @Bindable var appPaymentService = appPaymentService

    PaywallView(displayCloseButton: showDismiss)
      .onRequestedDismissal {
        appPaymentService.shouldShowPaywall.toggle()
        Analytics.shared
          .logEvent(with: .paywallDismissed, parameters: [.paywallSource: source])
      }
      .onRestoreCompleted { customerInfo in
        analyticsHookForRestoreSuccess(customerInfo: customerInfo)
      }
      .onRestoreFailure { _ in
        analyticsHookRestoreFailed()
      }
      .onPurchaseCompleted { transaction, customerInfo in
        Analytics.shared.logEvent(
          with: .purchase,
          parameters: [
            .activeSubscriptions: customerInfo.activeSubscriptions.map({ $0 })
              .joined(
                separator: ","
              ),
            .paywallTrigger: appPaymentService.lastUsedTrigger ?? "NO_TRIGGER",
            .paywallSource: source,
          ]
        )
      }
  }

  func analyticsHookForRestoreSuccess(customerInfo: CustomerInfo) {
    Analytics.shared.logEvent(
      with: .purchaseRestoreCompleted,
      parameters: [
        .restoreSuccessful: true,
        .paywallSource: source,
        .paywallTrigger: appPaymentService.lastUsedTrigger ?? "NO_TRIGGER",
        .activeSubscriptions: customerInfo.activeSubscriptions.map({ $0 }).joined(separator: ","),
      ]
    )
  }

  func analyticsHookRestoreFailed() {
    Analytics.shared.logEvent(
      with: .purchaseRestoreCompleted,
      parameters: [
        .restoreSuccessful: false,
        .paywallSource: source,
        .paywallTrigger: appPaymentService.lastUsedTrigger ?? "NO_TRIGGER",
      ]
    )
  }
}

// Viewmodifier that will control when to show or hide paywall in a sheet based on AppPaymentService
struct HogPaywallModifier: ViewModifier {
  @Environment(AppPaymentService.self) var appPaymentService

  var showDismiss: Bool
  var source: PaywallSource

  func body(content: Content) -> some View {
    @Bindable var appPaymentService = appPaymentService
    content
      .sheet(isPresented: $appPaymentService.shouldShowPaywall) {
        HogPaywallView(showDismiss: showDismiss, source: source)
      }
  }

  func analyticsHookForRestoreSuccess(customerInfo: CustomerInfo) {
    Analytics.shared.logEvent(
      with: .purchaseRestoreCompleted,
      parameters: [
        .restoreSuccessful: true,
        .paywallSource: source,
        .paywallTrigger: appPaymentService.lastUsedTrigger ?? "NO_TRIGGER",
        .activeSubscriptions: customerInfo.activeSubscriptions.map({ $0 }).joined(separator: ","),
      ]
    )
  }

  func analyticsHookRestoreFailed() {
    Analytics.shared.logEvent(
      with: .purchaseRestoreCompleted,
      parameters: [
        .restoreSuccessful: false,
        .paywallSource: source,
        .paywallTrigger: appPaymentService.lastUsedTrigger ?? "NO_TRIGGER",
      ]
    )
  }
}

extension View {
  func hogPaywall(showDismiss: Bool = true, source: PaywallSource) -> some View {
    modifier(
      HogPaywallModifier(showDismiss: showDismiss, source: source)
    )
  }
}
