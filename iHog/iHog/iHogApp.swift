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

  let analtyics = Analytics.shared

  let persistenceController = PersistenceController.shared

  init() {
    Purchases.logLevel = .debug
    Purchases.configure(
      with: Configuration.Builder(withAPIKey: RCConstants.apiKey)
        .build()
    )
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
          } else {
            SettingsView()
              .environment(\.managedObjectContext, persistenceController.container.viewContext)
              .environmentObject(osc)
              .environmentObject(user)
              .environmentObject(toastNotification)
          }
        }
      }
      .task {
        analtyics.logEvent(with: .appLaunched)
        increaseTimesLaunchedAndAskReview()
        do {
          try await getCustomerInfo()
          user.offerings = try await Purchases.shared.offerings()
          for await customerInfo in Purchases.shared.customerInfoStream {
            for _ in customerInfo.activeSubscriptions {
              HogLogger.log(category: .purchases).debug("🐛 \(customerInfo.activeSubscriptions)")
            }
            user.customerInfo = customerInfo
          }
        } catch {
          Analytics.shared.logError(with: error, for: .purchases, level: .critical)
        }
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

  func getCustomerInfo() async throws {
    user.customerInfo = try await Purchases.shared.restorePurchases()
    analtyics.identifyUser(with: Purchases.shared.appUserID)
  }
}
