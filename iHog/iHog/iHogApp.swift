//
//  iHogApp.swift
//  iHog
//
//  Created by Jay on 1/20/24.
//

import SwiftUI

@main
struct iHogApp: App {
  let persistenceController = PersistenceController.shared

  var body: some Scene {
    WindowGroup {
      LaunchScreenView()
        .environment(\.managedObjectContext, persistenceController.container.viewContext)
    }
  }
}
