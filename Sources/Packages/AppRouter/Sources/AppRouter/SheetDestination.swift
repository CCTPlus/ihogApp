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
  case paywall
  case newBoard
}

extension SheetDestination: Identifiable {
  public var id: String {
    switch self {
      case .userProfile: "userProfile"
      case .newShow: "newShow"
      case .paywall: "paywall"
      case .newBoard: "newBoard"
    }
  }

  public var analyticName: String {
    switch self {
      case .userProfile: "Sheet.UserProfile"
      case .newShow: "Sheet.NewShow"
      case .paywall: "Sheet.Paywall"
      case .newBoard: "Sheet.NewBoard"
    }
  }
}
