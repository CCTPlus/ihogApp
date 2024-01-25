//
//  AccessLevelManager.swift
//  iHog
//
//  Created by Jay on 1/22/24.
//

import Foundation
import RevenueCat

@Observable
class UserLevelManager {
  var userLevel: AccessLevel

  init(userLevel: AccessLevel = .free) {
    self.userLevel = userLevel
  }

  func determineUserLevel(_ canConnectToRC: Bool) {
    if canConnectToRC {
      Task {
        do {
          try await determineAccessLevelFromRevenueCat()
        } catch {
          determineAccessLevelFromUserDefaults()
        }
      }
    } else {
      determineAccessLevelFromUserDefaults()
    }
  }

  private func determineAccessLevelFromUserDefaults() {
    let storedValue = UserDefaults.standard.bool(forKey: UserDefaultKey.proIsActive)
    if storedValue {
      userLevel = .pro
    } else {
      userLevel = .free
    }
  }

  private func determineAccessLevelFromRevenueCat() async throws {
    let entitlements = try await Purchases.shared.customerInfo().entitlements
    if entitlements[RCConstant.Entitlement.pro]?.isActive == true {
      userLevel = .pro
      UserDefaults.standard.set(true, forKey: UserDefaultKey.proIsActive)
    } else {
      userLevel = .free
      UserDefaults.standard.set(false, forKey: UserDefaultKey.proIsActive)
    }
  }
}
