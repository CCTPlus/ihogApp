//
//  OSCManager.swift
//  iHog
//
//  Created by Jay on 2/9/24.
//

import Foundation

extension OSCManager: Mockable {
  typealias MockType = OSCManager
  static var mock: OSCManager {
    OSCManager(outputPort: 1213, consoleInputPort: 1312)
  }
}
