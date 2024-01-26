//
//  RevenueCat+Extensions.swift
//  iHog
//
//  Created by Jay on 1/26/24.
//

import Foundation
import RevenueCat

extension SubscriptionPeriod {
  var viewUnit: String {
    switch unit {
      case .day:
        "day"
      case .week:
        "week"
      case .month:
        "month"
      case .year:
        "year"
    }
  }
}
