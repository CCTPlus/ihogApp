//
//  OSCManager.swift
//  iHog
//
//  Created by Jay on 2/6/24.
//

import Foundation
import OSCKit
import OSLog

@Observable
class OSCManager {
  var server: OSCServer
  private var client: OSCClient

  /// IP address of the console. Defaults to the hognet ip address
  private var consoleIPAddress: String
  /// The port the console receives OSC messages on
  private var consoleInputPort: Int

  private var safeInputPort: UInt16 {
    UInt16(consoleInputPort)
  }

  // MARK: Received values
  var commandLine: String = ""
  var consoleTime: String = ""
  var leds: [HogKey: Bool] = [
    .intensity: false,
    .position: false,
    .color: false,
    .beam: false,
    .effect: false,
    .time: false,
    .group: false,
    .fixture: false,
  ]

  init(outputPort: Int, consoleInputPort: Int, consoleIPAddress: String = "172.31.0.1") {
    self.server = OSCServer(port: UInt16(outputPort))
    self.consoleInputPort = consoleInputPort
    self.consoleIPAddress = consoleIPAddress
    self.client = OSCClient()
  }

  func configureServer(with port: Int) {
    server = OSCServer(port: UInt16(port)) { [weak self] message, _ in
      self?.readMessage(message: message)
    }
  }

  func configureConsoleInformation(port: Int, ipAddress: String?) {
    if let ipAddress {
      consoleIPAddress = ipAddress
    }
    consoleInputPort = port
  }

  func sendTestMessage() throws {
    let oscMessage = OSCMessage("/hog/0/test")
    Logger.osc.debug("Message sending to \(self.consoleIPAddress) \(self.safeInputPort)")
    try client.send(oscMessage, to: consoleIPAddress, port: safeInputPort)
  }

  func toggleOSC() throws {
    if server.isStarted {
      server.stop()
      Logger.osc.debug("🚨 stopped server")
    } else {
      try server.start()
      Logger.osc.debug("🚨 started server")
    }
  }

  func push(button: HogKey) throws {
    let messageDown = OSCMessage(button.oscAddress, values: [1])
    let messageUp = OSCMessage(button.oscAddress, values: [0])

    try client.send(messageDown, to: consoleIPAddress, port: safeInputPort)
    try client.send(messageUp, to: consoleIPAddress, port: safeInputPort)
  }
}
