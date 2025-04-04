//
// -----------------------------------------------------------
// Project: iHog
// Created on 4/1/25 by @HeyJayWilson
// -----------------------------------------------------------
// Find HeyJayWilson on the web:
// 🕸️ Website             https://heyjaywilson.com
// 💻 Follow on GitHub:   https://github.com/heyjaywilson
// 🧵 Follow on Threads:  https://threads.net/@heyjaywilson
// 💭 Follow on Mastodon: https://iosdev.space/@heyjaywilson
// ☕ Buy me a ko-fi:     https://ko-fi.com/heyjaywilson
// -----------------------------------------------------------
// Copyright© 2025 CCT Plus LLC. All rights reserved.
//

import Foundation
import OSLog

public enum LogCategory: String {
  case `default`
  case analytics
  case error
  case purchases
  case osc
  case haptics
  case coreData
  case swiftData
  case hogData
  case show
}

public struct HogLogger {
  public static func log(category: LogCategory = .default) -> Logger {
    let bundleID =
      Bundle.main.infoDictionary?["CFBundleIdentifier"] as? String ?? "com.appsbymw.hogosc"
    return Logger(subsystem: bundleID, category: category.rawValue)
  }

  public init() {}

  public func getLogs() throws -> URL {
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
  public var description: String {
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

public enum HogLoggerError: Error {
  case notAbleToCreateFile

  public var localizedDescription: String {
    switch self {
      case .notAbleToCreateFile: return "Unable to create log file."
    }
  }
}
