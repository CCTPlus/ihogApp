//
//  Router.swift
//  iHog
//
//  Created by Jay Wilson on 11/24/24.
//

import Foundation
import SwiftUI

extension EnvironmentValues {
  @Entry public var currentTab: AppTab = .settings
}

public enum AppTab: CaseIterable, Identifiable, Hashable, Sendable {
  case programming
  case playback
  case puntPage
  case settings

  public var id: Int {
    self.hashValue
  }

  public var icon: String {
    switch self {
      case .programming:
        "paintpalette"
      case .settings:
        "gearshape"
      case .playback:
        "play"
      case .puntPage:
        "keyboard"
    }
  }

  // DO NOT CHANGE THESE WITHOUT CONSULTING WITH JAY
  public var analyticsValue: String {
    switch self {
      case .programming:
        "Programming"
      case .settings:
        "Settings"
      case .playback:
        "Playback"
      case .puntPage:
        "Punt Page"
    }
  }
}
