//
//  TipEntity.swift
//  iHog
//
//  Created by Jay Wilson on 11/10/24.
//
//

import Foundation
import SwiftData

// This class is NO LONGER USED. The app is subscription model, so no lnoger asking for tips.
@available(iOS 17, *)
@Model public final class TipEntity {
  public var amount: Double? = 0.0
  public var dateTipped: Date?

  public init(amount: Double? = nil, dateTipped: Date? = nil) {
    self.amount = amount
    self.dateTipped = dateTipped
  }
}
