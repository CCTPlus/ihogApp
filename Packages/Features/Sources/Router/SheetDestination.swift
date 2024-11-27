//
//  SheetDestination.swift
//  Features
//
//  Created by Jay Wilson on 11/25/24.
//

import Foundation

public enum SheetDestination: Hashable, Identifiable {
  public var id: Int { hashValue }

  case newShow
}
