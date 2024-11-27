//
//  HogOSCError.swift
//  Utilities
//
//  Created by Jay Wilson on 11/25/24.
//

public enum HogOSCError: Error {
  case noAppGroupURL
  case notAbleToLoadStore

  public var localizedDescription: String {
    switch self {
      case .noAppGroupURL:
        "Shared file container could not be created"
      case .notAbleToLoadStore:
        "Could not load a persistent store"
    }
  }
}
