//
//  OSCHelper+Server.swift
//  iHog
//
//  Created by Jay Wilson on 1/11/22.
//

import Foundation
import OSCKit

extension OSCHelper: OSCUdpServerDelegate {
  func server(
    _ server: OSCUdpServer,
    didReceivePacket packet: OSCPacket,
    fromHost host: String,
    port: UInt16
  ) {
    readBundle(bundle: OSCBundle([packet]))
  }

  func server(
    _ server: OSCUdpServer,
    socketDidCloseWithError error: Error?
  ) {
    if let error = error {
      print("UDP server did stop listening with error: \(error.localizedDescription)")
    } else {
      print("UDP server did stop listening")
    }
  }

  func server(
    _ server: OSCUdpServer,
    didReadData data: Data,
    with error: Error
  ) {
    print("UDP Server did read data with error: \(error.localizedDescription)")
  }
}

extension OSCHelper: OSCTcpServerDelegate {
  func server(
    _ server: OSCTcpServer,
    didConnectToClientWithHost host: String,
    port: UInt16
  ) {
    print("TCP Server did connect to client \(host):\(port)")
  }

  func server(
    _ server: OSCTcpServer,
    didDisconnectFromClientWithHost host: String,
    port: UInt16
  ) {
    print("TCP Server did disconnect from client \(host):\(port)")
  }

  func server(
    _ server: OSCTcpServer,
    didReceivePacket packet: OSCPacket,
    fromHost host: String,
    port: UInt16
  ) {
    print("TCP Server did receive packet")
  }

  func server(
    _ server: OSCTcpServer,
    didSendPacket packet: OSCPacket,
    toClientWithHost host: String,
    port: UInt16
  ) {
    print("TCP Server did send packet to \(host):\(port)")
  }

  func server(
    _ server: OSCTcpServer,
    socketDidCloseWithError error: Error?
  ) {
    if let error = error {
      print("TCP server did stop listening with error: \(error.localizedDescription)")
    } else {
      print("TCP server did stop listening")
    }
  }

  func server(
    _ server: OSCTcpServer,
    didReadData data: Data,
    with error: Error
  ) {
    print("TCP Server did read data with error: \(error.localizedDescription)")
  }
}
