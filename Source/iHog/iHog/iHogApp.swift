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

import HogAnalytics
import HogData
import HogEnvironment
import HogRouter
import HogSettings
import HogShow
import HogUtilities
import RevenueCat
import StoreKit
import SwiftUI

@main
struct iHogApp: App {
  @AppStorage(AppSetting.timesLaunched.rawValue) var timesLaunched: Int = 0
  @AppStorage(AppSetting.showOnboarding.rawValue) var showOnboarding: Bool = true

  @Environment(\.requestReview) var requestReview
  @Environment(\.analytics) var analytics
  @Environment(\.persistenceController) var persistenceController

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
      ZStack {
        SettingsView()
          .withHogEnvironment()
        if case .show(let showID) = hogRouter.routerDestination {
          HogShowView(
            viewModel: HogShowViewModel(
              persistenceController: persistenceController,
              showID: showID
            )
          )
        }
      }
    }
    .environment(hogRouter)
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
    analytics.identifyUser(with: Purchases.shared.appUserID)
  }
}
