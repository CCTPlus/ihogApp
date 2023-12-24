//
//  iHogApp.swift
//  iHog
//
//  Created by Jay on 12/22/23.
//

import AppInfoCore
import AppView
import ComposableArchitecture
import SwiftUI

@main
struct iHogApp: App {
  let persistenceController = PersistenceController.shared

  var body: some Scene {
    WindowGroup {
      AppView(
        appInfoStore: Store(initialState: AppInfoFeature.State()) {
          AppInfoFeature()
        }
      )
    }
  }
}
