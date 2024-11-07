//
//  UserState.swift
//  iHog
//
//  Created by Jay Wilson on 8/11/22.
//

import Foundation
import Combine
import RevenueCat

class UserState: NSObject, ObservableObject {
    static let shared = UserState()

    @Published var navigation: Routes? = .osc

    @Published var offerings: Offerings? = nil
    @Published var customerInfo: CustomerInfo? {
        didSet {
            guard let customerInfo else {
                purchasedApp = false
                proSubscriptionActive = false
                purchasedApp = false
                return
            }
            purchasedApp = (customerInfo.originalPurchaseDate ?? Date.now) < RCConstants().getConvertedToSubscriptionDate()!
            puntPageActive = customerInfo.entitlements[RCConstants.Entitlements.puntPage.rawValue]?.isActive == true
            proSubscriptionActive = customerInfo.entitlements[RCConstants.Entitlements.pro.rawValue]?.isActive == true
        }
    }

    var puntPageActive: Bool = false
    var proSubscriptionActive: Bool = false
    var purchasedApp: Bool = false

    var isPro: Bool {
        if purchasedApp {
            return true
        } else if puntPageActive {
            return true
        } else if proSubscriptionActive {
            return true
        }
        return false
    }

    func unlockPro() {
        proSubscriptionActive = true
    }

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
