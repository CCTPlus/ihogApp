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
  @AppStorage(UserDefaultKey.proIsActive) var proIsActive = false

  @State var network = NetworkManager()
  @State var userLevelManager = UserLevelManager()

  let persistenceController = PersistenceController.shared

  init() {
    Purchases.logLevel = .debug
    Purchases.configure(withAPIKey: RCConstant.APIKEY)
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
    }
  }
}
