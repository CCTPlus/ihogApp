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
  var commandLine: String = "Command line waiting..."
  var consoleTime: String = ""
  var blueLeds: [HogKey: Bool] = [
    .intensity: false,
    .position: false,
    .color: false,
    .beam: false,
    .effect: false,
    .time: false,
    .group: false,
    .fixture: false,
  ]

  var redLeds: [HogKey: PlaybackKey] = [:]

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

  func push(address: String) {
    let messageDown = OSCMessage(address, values: [1])
    do {
      try client.send(messageDown, to: consoleIPAddress, port: safeInputPort)
    } catch {
      Logger.osc.error("Pushing down button did not send \(error)")
    }
    Logger.osc.debug("💬 \(messageDown.addressPattern)")
  }

  func release(address: String) {
    let messageUp = OSCMessage(address, values: [0])
    do {
      try client.send(messageUp, to: consoleIPAddress, port: safeInputPort)
    } catch {
      Logger.osc.error("Releasing button did not send \(error)")
    }
    Logger.osc.debug("💬 \(messageUp.addressPattern)")
  }

  func sendListSceneCommand(address: String, value: [Double]) {
    let message = OSCMessage(address, values: value)
    do {
      try client.send(message, to: consoleIPAddress, port: safeInputPort)
    } catch {
      Logger.osc.error("\(#function) \(error)")
    }
    Logger.osc.debug("💬 \(message.addressPattern) \(message.values)")
  }

  func sendEncoder(number: Int, isPositive: Bool) {
    let address = "/hog/hardware/encoderwheel/\(number)"
    let message = OSCMessage(address, values: [isPositive ? -2.0 : 2.0])
    do {
      try client.send(message, to: consoleIPAddress, port: safeInputPort)
    } catch {
      Logger.osc.error("\(#function) \(error)")
    }
    Logger.osc.debug("💬 \(message.addressPattern) \(message.values)")
  }
}
