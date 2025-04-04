//
// -----------------------------------------------------------
// Project: iHog
// Created on 4/3/25 by @HeyJayWilson
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

import SwiftUI

public struct AnalyticsKey: EnvironmentKey {
  nonisolated(unsafe)
    public static var defaultValue: HogAnalytics = HogAnalytics()
}

extension EnvironmentValues {
  public var analytics: HogAnalytics {
    get { self[AnalyticsKey.self] }
    set { self[AnalyticsKey.self] = newValue }
  }
}
