//
//  iHogApp.swift
//  iHog
//
//  Created by Jay on 1/20/24.
//

import RevenueCat
import SwiftUI

@main
struct iHogApp: App {
  @AppStorage(UserDefaultKey.proIsActive.rawValue) var proIsActive = false

  @State var network = NetworkManager()
  @State var userLevelManager = UserLevelManager()
  /// This is configured with the default Hog settings
  @State var oscManager = OSCManager(outputPort: 7002, consoleInputPort: 7001)

  let persistenceController = PersistenceController.shared

  init() {
    Purchases.logLevel = .debug
    Purchases.configure(withAPIKey: RCConstant.APIKEY)
    UserDefaults.standard.set(false, forKey: UserDefaultKey.isOSCEnabled.rawValue)
  }

  var body: some Scene {
    WindowGroup {
      LaunchScreenView()
        .task {
          userLevelManager.determineUserLevel(network.isConnected)
          userLevelManager.determineProSince(network.isConnected)
          userLevelManager.determineUserSince(network.isConnected)
        }
        .environment(\.managedObjectContext, persistenceController.container.viewContext)
        .environment(network)
        .environment(userLevelManager)
        .environment(oscManager)
    }
  }
}
