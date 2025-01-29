//
//  UserStateManager.swift
//  iHog
//
//  Created by Jay Wilson on 1/24/25.
//

import Foundation

@Observable
class UserStateManager {
  var isPro: Bool = false

  init(isPro: Bool) {
    self.isPro = isPro
  }

  // TODO: IMPLEMENT FULLY
  func checkIfPro() {
    fatalError("Called without implementation")
  }
}
