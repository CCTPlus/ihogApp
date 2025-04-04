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
import SwiftUI
import UIKit

public enum DeviceType: Sendable {
  case iPhone
  case iPad
  case iPadMini

  public static var current: DeviceType {
    var systemInfo = utsname()
    uname(&systemInfo)
    let machineMirror = Mirror(reflecting: systemInfo.machine)
    let identifier = machineMirror.children.reduce("") { identifier, element in
      guard let value = element.value as? Int8, value != 0 else { return identifier }
      return identifier + String(UnicodeScalar(UInt8(value)))
    }

    // Check if it's an iPhone first
    if identifier.starts(with: "iPhone") {
      return .iPhone
    }

    // Check if iPad Mini
    if identifier.contains("iPad") && identifier.contains("Mini") {
      return .iPadMini
    }

    // All other iPads
    return .iPad
  }
}

public struct DeviceKey: EnvironmentKey {
  public static let defaultValue: DeviceType = .current
}

extension EnvironmentValues {
  public var deviceType: DeviceType {
    get { self[DeviceKey.self] }
    set { self[DeviceKey.self] = newValue }
  }
}
