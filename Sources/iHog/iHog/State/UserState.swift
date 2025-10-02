//
//  UserState.swift
//  iHog
//
//  Created by Jay Wilson on 8/11/22.
//

import Combine
import Foundation
import RevenueCat

class UserState: NSObject, ObservableObject {
  static let shared = UserState()

  @Published var navigation: Routes? = .osc

  func setNavigation(to route: Routes) {
    DispatchQueue.main.async {
      self.navigation = route
    }
  }

  func resetNavigation() {
    DispatchQueue.main.async {
      self.navigation = nil
    }
  }
}
