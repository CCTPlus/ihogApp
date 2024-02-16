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
    let storedValue = UserDefaults.standard.bool(forKey: UserDefaultKey.proIsActive.rawValue)
    if storedValue {
      userLevel = .pro
    } else {
      userLevel = .free
    }
  }

  private func determineAccessLevelFromRevenueCat() async throws {
    let entitlements = try await Purchases.shared.customerInfo().entitlements
    Logger.iap.debug("\(entitlements[RCConstant.Entitlement.pro])")
    await MainActor.run {
      if entitlements[RCConstant.Entitlement.pro]?.isActive == true {
        userLevel = .pro
        UserDefaults.standard.set(true, forKey: UserDefaultKey.proIsActive.rawValue)
      } else {
        userLevel = .free
        UserDefaults.standard.set(false, forKey: UserDefaultKey.proIsActive.rawValue)
      }
    }
  }

  private func determineDatesFromUserDefaults() {
    let userSinceDateString = UserDefaults.standard.string(
      forKey: UserDefaultKey.userSince.rawValue
    )
    let proSinceDateString = UserDefaults.standard.string(forKey: UserDefaultKey.proSince.rawValue)

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
    await MainActor.run {
      UserDefaults.standard.set(
        purchaseDate.ISO8601Format(),
        forKey: UserDefaultKey.userSince.rawValue
      )
      userSince = purchaseDate
      Logger.iap.debug("User since \(purchaseDate.ISO8601Format())")
    }
  }

  private func determineProSinceFromRevenueCat() async throws {
    let info = try await Purchases.shared.customerInfo()
    let purchaseDate = info.purchaseDate(forEntitlement: RCConstant.Entitlement.pro)
    guard let purchaseDate else { return }
    UserDefaults.standard.set(
      purchaseDate.ISO8601Format(),
      forKey: UserDefaultKey.proSince.rawValue
    )
    proSince = purchaseDate
    Logger.iap.debug("Pro since \(purchaseDate.ISO8601Format())")
  }

  func startListeningForRevenueCatChanges() async {
    let infos = Purchases.shared.customerInfoStream
    for await info in infos {
      Logger.iap.debug("\(info.entitlements.activeInCurrentEnvironment)")
      determineUserSince(true)
      determineUserLevel(true)
      determineProSince(true)
    }
  }
}
