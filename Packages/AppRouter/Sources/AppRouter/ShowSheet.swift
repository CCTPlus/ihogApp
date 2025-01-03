//
//  ShowSheet.swift
//  AppRouter
//
//  Created by Jay Wilson on 1/3/25.
//

public enum ShowSheet: String, Identifiable {
  case showNotes

  public var id: String {
    rawValue
  }

  public var analyticName: String {
    switch self {
      case .showNotes:
        "Sheet.showNotes"
    }
  }
}
