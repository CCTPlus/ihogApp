//
//  AppInfo.swift
//  iHog
//
//  Created by Jay Wilson on 12/5/24.
//

import Foundation

enum AppInfo {
  static let appGroup = "group.com.appsbymw.hogosc"
  /// Current version of the app
  static let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
  /// Current build number of the app
  static let build = Bundle.main.infoDictionary?["CFBundleVersion"] as? String
  /// App's display name
  static let name = Bundle.main.infoDictionary?["CFBundleDisplayName"] as? String
}
