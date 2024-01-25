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

  let persistenceController = PersistenceController.shared

  init() {
    Purchases.logLevel = .debug
    Purchases.configure(withAPIKey: RCConstant.APIKEY)
  }

  var body: some Scene {
    WindowGroup {
      LaunchScreenView()
        .environment(\.managedObjectContext, persistenceController.container.viewContext)
        .environment(network)
    }
  }
}
