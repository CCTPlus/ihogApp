//
//  iHogApp.swift
//  iHog
//
//  Created by Jay on 12/22/23.
//

import AppView
import SwiftUI

@main
struct iHogApp: App {
  let persistenceController = PersistenceController.shared

  var body: some Scene {
    WindowGroup {
      AppView()
      //            ContentView()
      //                .environment(\.managedObjectContext, persistenceController.container.viewContext)
    }
  }
}
