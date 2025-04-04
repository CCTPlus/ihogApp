//
//  iHogApp.swift
//  iHog
//
//  Created by Jay Wilson on 9/16/20.
//  Supporters:
//  DustinD_Miller
//  panjakesnbacon
//  MikaelaCaron - 2022-09-21
//

import CoffeeToast
import HogAnalytics
import HogData
import HogRouter
import HogSettings
import HogUtilities
import RevenueCat
import StoreKit
import SwiftUI

class ToastNotification: ObservableObject {
  @Published var isShown = false
  var color = Color.clear
  var text = ""

  let ms = 1_000_000

  func animateIn(text: String, color: Color) {
    self.text = text
    self.color = color

    DispatchQueue.main.async {
      self.isShown = true
    }

    DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
      self.isShown = false
    }
  }
}

@main
struct iHogApp: App {
  @AppStorage(AppStorageKey.timesLaunched.rawValue) var timesLaunched: Int = 0
  @AppStorage(AppStorageKey.showOnboarding.rawValue) var showOnboarding: Bool = true

  @Environment(\.requestReview) var requestReview
  @Environment(\.analytics) var analytics

  @StateObject var osc = OSCHelper(ip: "192.168.0.101", inputPort: 9009, outputPort: 9009)
  @StateObject var user = UserState()

  @State private var hogRouter = HogRouter()

  init() {
    Purchases.logLevel = .debug
    Purchases.configure(
      with: Configuration.Builder(withAPIKey: RCConstants.apiKey)
        .build()
    )
  }

  var body: some Scene {
    WindowGroup {
      SettingsView()
        .environment(hogRouter)
    }
  }
}

extension iHogApp {
  func increaseTimesLaunchedAndAskReview() {
    HogLogger.log().info("App launched times: \(timesLaunched)")
    timesLaunched += 1
    if timesLaunched >= 10 {
      requestReview()
    }
  }

  func getCustomerInfo() async throws {
    user.customerInfo = try await Purchases.shared.restorePurchases()
    analytics.identifyUser(with: Purchases.shared.appUserID)
  }
}
