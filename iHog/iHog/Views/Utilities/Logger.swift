//
//  Untitled.swift
//  iHog
//
//  Created by Jay Wilson on 11/7/24.
//

import Foundation
import OSLog

enum LogCategory: String {
  case `default`
  case analytics
  case error
  case purchases
  case osc
  case haptics
  case coreData
  case swiftData
}

struct HogLogger {
  static func log(category: LogCategory = .default) -> Logger {
    let bundleID =
      Bundle.main.infoDictionary?["CFBundleIdentifier"] as? String ?? "com.appsbymw.hogosc"
    return Logger(subsystem: bundleID, category: category.rawValue)
  }
}
