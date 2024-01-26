//
//  Logger.swift
//  iHog
//
//  Created by Jay on 1/22/24.
//

import Foundation
import OSLog

enum LoggerCategory: String {
  case networkMonitor
  case user
  case iap
}

extension Logger {
  private static let subsystem = Bundle.main.bundleIdentifier!
  static let networkMonitor = Logger(
    subsystem: subsystem,
    category: LoggerCategory.networkMonitor.rawValue
  )
  static let user = Logger(
    subsystem: subsystem,
    category: LoggerCategory.user.rawValue
  )
  static let iap = Logger(
    subsystem: subsystem,
    category: LoggerCategory.iap.rawValue
  )
}
