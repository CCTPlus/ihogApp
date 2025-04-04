//
// -----------------------------------------------------------
// Project: iHog
// Created on 4/2/25 by @HeyJayWilson
// -----------------------------------------------------------
// Find HeyJayWilson on the web:
// 🕸️ Website             https://heyjaywilson.com
// 💻 Follow on GitHub:   https://github.com/heyjaywilson
// 🧵 Follow on Threads:  https://threads.net/@heyjaywilson
// 💭 Follow on Mastodon: https://iosdev.space/@heyjaywilson
// ☕ Buy me a ko-fi:     https://ko-fi.com/heyjaywilson
// -----------------------------------------------------------
// Copyright©t 2025 CCT Plus LLC. All rights reserved.
//

import SwiftUI

/// Environment key for accessing HogPersistenceController throughout the app
public struct PersistenceControllerKey: EnvironmentKey {
  nonisolated(unsafe)
    public static var defaultValue: HogPersistenceController = {
      if ProcessInfo.processInfo.environment["XCODE_RUNNING_FOR_PREVIEWS"] == "1" {
        return HogPersistenceController(inMemory: true)
      }
      return HogPersistenceController()
    }()
}

extension EnvironmentValues {
  public var persistenceController: HogPersistenceController {
    get { self[PersistenceControllerKey.self] }
    set { self[PersistenceControllerKey.self] = newValue }
  }
}
