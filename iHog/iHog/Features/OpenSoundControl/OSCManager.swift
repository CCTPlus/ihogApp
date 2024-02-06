//
//  OSCManager.swift
//  iHog
//
//  Created by Jay on 2/6/24.
//

import Foundation
import OSCKit

@Observable
class OSCManager {
  var server: OSCServer
  private var client: OSCClient

  /// IP address of the console. Defaults to the hognet ip address
  var consoleIPAddress: String
  /// The port the console receives OSC messages on
  var consoleInputPort: Int

  private var safeInputPort: UInt16 {
    UInt16(consoleInputPort)
  }

  init(outputPort: Int, consoleInputPort: Int, consoleIPAddress: String = "172.31.0.1") {
    self.server = OSCServer(port: UInt16(outputPort))
    self.consoleInputPort = consoleInputPort
    self.consoleIPAddress = consoleIPAddress
    self.client = OSCClient()
  }

  func configureServer(with port: Int) {
    server = OSCServer(port: UInt16(port)) { message, _ in
      print("Received \(message)")
    }
  }

  func configureConsoleInformation(port: Int, ipAddress: String?) {
    if let ipAddress {
      consoleIPAddress = ipAddress
    }
    consoleInputPort = port
  }

  func sendTestMessage() throws {
    let oscMessage = OSCMessage("/hog/0/tet")
    try client.send(oscMessage, to: consoleIPAddress, port: safeInputPort)
  }

  func toggleOSC() throws {
    if server.isStarted {
      server.stop()
    } else {
      try server.start()
    }
  }
}
