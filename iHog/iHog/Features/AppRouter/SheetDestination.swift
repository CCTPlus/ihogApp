//
//  SheetDestination.swift
//  iHog
//
//  Created by Jay on 1/25/24.
//

import Foundation

enum SheetDestination: Identifiable {
  var id: Int {
    self.hashValue
  }

  case newShow
  case proDetail
}
