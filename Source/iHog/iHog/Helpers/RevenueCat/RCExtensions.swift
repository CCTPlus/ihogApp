//
//  RCExtensions.swift
//  iHog
//
//  Created by Jay Wilson on 8/11/22.
//

import Foundation
import RevenueCat

extension Package {
  var hasFreeTrial: Bool {
    if let intro = self.storeProduct.introductoryDiscount {
      return intro.price == 0
    }
    return false
  }
  var isSubscription: Bool {
    self.storeProduct.subscriptionPeriod != nil
  }
  var discountTerms: String {
    if let intro = self.storeProduct.introductoryDiscount {
      if intro.price == 0 {
        return "\(intro.subscriptionPeriod.periodTitlePlural)"
      } else {
        return
          "\(self.localizedIntroductoryPriceString!) for \(intro.subscriptionPeriod.periodTitle)"
      }
    } else {
      return ""
    }
  }
  func terms(for package: Package) -> String {
    if let intro = package.storeProduct.introductoryDiscount {
      if intro.price == 0 {
        return "\(intro.subscriptionPeriod.periodTitle) free trial"
      } else {
        return
          "\(package.localizedIntroductoryPriceString!) for \(intro.subscriptionPeriod.periodTitle)"
      }
    } else {
      return ""
    }
  }
}

extension SubscriptionPeriod {
  var durationTitle: String {
    switch self.unit {
      case .day: return "day"
      case .week: return "week"
      case .month: return "month"
      case .year: return "year"
      @unknown default: return "Unknown"
    }
  }
  var durationAdverb: String {
    switch self.unit {
      case .day: return "daily"
      case .week: return "weekly"
      case .month: return "monthly"
      case .year: return "yearly"
      @unknown default: return "Unknown"
    }
  }
  var periodTitle: String {
    let periodString = "\(self.value) \(self.durationTitle)"
    let pluralized = self.value > 1 ? periodString + "s" : periodString
    return self.durationTitle == "week" ? periodString : pluralized
  }

  var periodTitlePlural: String {
    let periodString = "\(self.value) \(self.durationTitle)"
    return self.value > 1 ? periodString + "s" : periodString
  }
}
