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

public enum AppInfo {
  /// App Group name
  public static let appGroup = "group.com.appsbymw.hogosc"
  /// Current version of the app
  public static let version =
    Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "0.0.0"
  /// Current build number of the app
  public static let build = Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "0"
  /// App's display name
  public static let name = Bundle.main.infoDictionary?["CFBundleDisplayName"] as? String ?? "iHog"
}
