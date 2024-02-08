//
//  HogStatus.swift
//  iHog
//
//  Created by Jay on 2/6/24.
//

import Foundation

enum HogStatus: String {
  case commandLine = "commandline"
  case consoleTime
  // MARK: Button
  case intensity
  case position
  case colour
  case beam
  case effects
  case time
  case group
  case fixture
  case flash

  func address(masterNumber: Int? = nil) -> String {
    let status = "hog/status/"
    switch self {
      case .commandLine:
        return status + self.rawValue
      case .intensity, .position, .colour, .beam, .effects, .time, .group, .fixture:
        return status + "led/" + self.rawValue
      case .consoleTime:
        return status + "time"
      case .flash:
        return status + "led/\(self.rawValue)/\(masterNumber ?? 0)"
    }
  }

  var hogKey: HogKey? {
    switch self {
      case .commandLine, .consoleTime:
        return nil
      case .intensity:
        return .intensity
      case .position:
        return .position
      case .colour:
        return .color
      case .beam:
        return .beam
      case .effects:
        return .effect
      case .time:
        return .time
      case .group:
        return .group
      case .fixture:
        return .fixture
      case .flash:
        return .flash
    }
  }
}
