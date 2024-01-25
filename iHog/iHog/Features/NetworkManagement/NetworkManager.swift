//
//  NetworkManager.swift
//  iHog
//
//  Created by Jay on 1/22/24.
//

import Foundation
import Network
import OSLog

@Observable
class NetworkManager {
  var isConnected = false

  private let monitor = NWPathMonitor()
  private let queue = DispatchQueue(label: "monitor")

  init(isConnected: Bool = false) {
    monitor.pathUpdateHandler = { path in
      self.isConnected = path.status == .satisfied
      Logger.networkMonitor.debug("detected change: \(isConnected)")
    }
    monitor.start(queue: queue)
  }

}
