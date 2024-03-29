//
//  OSCManager+Receiver.swift
//  iHog
//
//  Created by Jay on 2/6/24.
//

import Foundation
import OSCKitCore
import OSLog

extension OSCManager {
  func readMessage(message: OSCMessage) {
    let pattern = message.addressPattern

    if pattern.matches(localAddress: HogStatus.consoleTime.address()) {
      parseConsoleTime(message: message)
    } else if pattern.matches(localAddress: HogStatus.commandLine.address()) {
      parseCommandLine(message: message)
    } else if pattern.pathComponents[2].lowercased() == "led" {
      parseLEDStatus(message: message)
    } else {
      Logger.osc.debug("\(pattern.pathComponents)")
    }
  }

  private func parseConsoleTime(message: OSCMessage) {
    consoleTime = message.values.first as? String ?? ""
  }

  private func parseCommandLine(message: OSCMessage) {
    commandLine = message.values.first as? String ?? ""
  }

  private func parseLEDStatus(message: OSCMessage) {
    Logger.osc.debug("💬 \(message.addressPattern.stringValue) \(message.values)")
    // value of 0.0 = off, 1.0 = on
    guard let value = message.values.first as? Float else {
      Logger.osc.error("NO VALUE AVAILABLE")
      return
    }
    let isOn = value == Float(1)

    let statusString = message.addressPattern.pathComponents[3].lowercased()

    guard let statusButton = HogStatus(rawValue: statusString),
      let hogKey = statusButton.hogKey
    else {
      Logger.osc.error("NO STATUS AVAILABLE")
      return
    }

    switch hogKey {
      case .flash:
        let numString = message.addressPattern.pathComponents.last?.lowercased() ?? ""
        let num = Int(numString) ?? 0
        let playbackKey = PlaybackKey(key: hogKey, masterNumber: num, isOn: isOn)
        redLeds[hogKey] = playbackKey
      case .intensity, .position, .color, .beam, .effect, .time, .group, .fixture:
        blueLeds[hogKey] = isOn
      default:
        break
    }
  }
}
