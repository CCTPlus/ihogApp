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

  @StateObject var osc = OSCHelper(ip: "192.168.0.101", inputPort: 9009, outputPort: 9009)
  @StateObject var user = UserState()

  @State private var paymentService = AppPaymentService()

  let analtyics = Analytics.shared

  init() {
    // Setup the model container
    _ = SwiftDataManager.modelContainer
  }

  @StateObject private var toastNotification = ToastNotification()
  @State private var settings = SettingsNav.device

  var body: some Scene {
    WindowGroup {
      Group {
        Toast(
          toastNotification.text,
          backgroundColor: toastNotification.color,
          isShown: $toastNotification.isShown
        ) {
          if showOnboarding {
            OnboardingView(setting: $settings)
              .environmentObject(osc)
              .environmentObject(user)
              .environment(paymentService)
          } else {
            SettingsView()
              .environmentObject(osc)
              .environmentObject(user)
              .environmentObject(toastNotification)
              .environment(paymentService)
          }
        }
      }
      .modelContainer(SwiftDataManager.modelContainer)
      .task {
        paymentService.configure()
        analtyics.logEvent(with: .appLaunched)
        increaseTimesLaunchedAndAskReview()
      }
    }
  }
}

extension iHogApp {
  func increaseTimesLaunchedAndAskReview() {
    HogLogger.log().debug("🐛 App launched times: \(timesLaunched)")
    timesLaunched += 1
    if timesLaunched >= 10 {
      requestReview()
    }
  }
}
