//
// -----------------------------------------------------------
// Project: iHog
// Created on 4/4/25 by @HeyJayWilson
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

@Observable
@MainActor
public final class HogRouter {
  public var routerDestination: RouterDestination?

  public init(routerDestination: RouterDestination? = nil) {
    self.routerDestination = routerDestination
  }

  public func changeShow(to showID: UUID) {
    self.routerDestination = .show(showID)
  }
}
