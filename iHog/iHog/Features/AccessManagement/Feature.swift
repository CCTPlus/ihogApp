//
//  Feature.swift
//  iHog
//
//  Created by Jay on 1/22/24.
//

import Foundation

enum Feature: Int, Identifiable, CaseIterable {

  case show, icon, puntPage

  var id: Int {
    return self.rawValue
  }

  /// A value of 0 means that the feature is not accessible on the free plan
  var freeLimit: Int {
    switch self {
      case .show:
        1
      case .icon:
        0
      case .puntPage:
        0
    }
  }
}
