//
//  SheetDestination.swift
//  AppRouter
//
//  Created by Jay Wilson on 12/10/24.
//

import Foundation

public enum SheetDestination: String {
  case userProfile
  case newShow
}

extension SheetDestination: Identifiable {
  public var id: String {
    rawValue
  }

  public var analyticName: String {
    switch self {
      case .userProfile:
        "Sheet.UserProfile"
      case .newShow:
        "Sheet.NewShow"
    }
  }
}
