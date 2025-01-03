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
  case show
}

struct HogLogger {
  static func log(category: LogCategory = .default) -> Logger {
    let bundleID =
      Bundle.main.infoDictionary?["CFBundleIdentifier"] as? String ?? "com.appsbymw.hogosc"
    return Logger(subsystem: bundleID, category: category.rawValue)
  }

  func getLogs() throws -> URL {
    let store = try OSLogStore(scope: .currentProcessIdentifier)
    let position = store.position(timeIntervalSinceLatestBoot: 1)

    let entries =
      try store
      .getEntries(at: position)
      .compactMap { $0 as? OSLogEntryLog }.filter { $0.subsystem == "com.appsbymw.hogosc" }
      .map {
        "\($0.date.formatted()) | \($0.category) | \($0.level.description) | \($0.composedMessage)"
      }

    let logEntries = entries.joined(separator: "\n").data(using: .utf8)  // Create one giant string of all log messages

    guard let textURL = try logEntries?.dataToFile(fileName: "hog_logs.txt") else {
      throw HogLoggerError.notAbleToCreateFile
    }

    return textURL
  }
}

extension OSLogEntryLog.Level {
  var description: String {
    switch self {
      case .debug: return "DEBUG"
      case .info: return "INFO"
      case .error: return "ERROR"
      case .fault: return "FAULT"
      case .notice: return "NOTICE"
      case .undefined: return "UNDEFINED"
      @unknown default: return "DEFAULT"
    }
  }
}

enum HogLoggerError: Error {
  case notAbleToCreateFile

  var localizedDescription: String {
    switch self {
      case .notAbleToCreateFile: return "Unable to create log file."
    }
  }
}
