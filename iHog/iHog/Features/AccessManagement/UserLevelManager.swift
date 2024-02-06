//
//  UserLevelManager.swift
//  iHog
//
//  Created by Jay on 1/22/24.
//

import Foundation
import OSLog
import RevenueCat

@Observable
class UserLevelManager {
  var userLevel: AccessLevel
  var userSince: Date
  var proSince: Date?
  var proDateText: String {
    guard let proSince else { return "" }
    return proSince.formatted(date: .abbreviated, time: .omitted)
  }

  init(userLevel: AccessLevel = .free) {
    self.userLevel = userLevel
    self.userSince = Date()
    self.proSince = nil
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

  func determineUserSince(_ canConnectToRC: Bool) {
    if canConnectToRC {
      Task {
        do {
          try await determineUserSinceFromRevenueCat()
        } catch {
          determineDatesFromUserDefaults()
        }
      }
    }
  }

  func determineProSince(_ canConnectToRC: Bool) {
    if canConnectToRC {
      Task {
        do {
          try await determineProSinceFromRevenueCat()
        } catch {
          determineDatesFromUserDefaults()
        }
      }
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
    Logger.iap.debug("\(entitlements[RCConstant.Entitlement.pro])")
    if entitlements[RCConstant.Entitlement.pro]?.isActive == true {
      userLevel = .pro
      UserDefaults.standard.set(true, forKey: UserDefaultKey.proIsActive)
    } else {
      userLevel = .free
      UserDefaults.standard.set(false, forKey: UserDefaultKey.proIsActive)
    }
  }

  private func determineDatesFromUserDefaults() {
    let userSinceDateString = UserDefaults.standard.string(forKey: UserDefaultKey.userSince)
    let proSinceDateString = UserDefaults.standard.string(forKey: UserDefaultKey.proSince)

    let dateFormatter = ISO8601DateFormatter()

    if let userSinceDateString {
      userSince = dateFormatter.date(from: userSinceDateString) ?? Date()
    }

    if let proSinceDateString {
      proSince = dateFormatter.date(from: proSinceDateString)
    }
  }

  private func determineUserSinceFromRevenueCat() async throws {
    let info = try await Purchases.shared.customerInfo()
    let purchaseDate = info.originalPurchaseDate
    guard let purchaseDate else { return }
    UserDefaults.standard.set(purchaseDate.ISO8601Format(), forKey: UserDefaultKey.userSince)
    userSince = purchaseDate
    Logger.iap.debug("User since \(purchaseDate.ISO8601Format())")
  }

  private func determineProSinceFromRevenueCat() async throws {
    let info = try await Purchases.shared.customerInfo()
    let purchaseDate = info.purchaseDate(forEntitlement: RCConstant.Entitlement.pro)
    guard let purchaseDate else { return }
    UserDefaults.standard.set(purchaseDate.ISO8601Format(), forKey: UserDefaultKey.proSince)
    proSince = purchaseDate
    Logger.iap.debug("Pro since \(purchaseDate.ISO8601Format())")
  }
}
