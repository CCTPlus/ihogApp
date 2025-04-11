//
//  networkMonitor.swift
//  iHog
//
//  Created by Jay Wilson on 9/21/22.
//

import Network

class NetworkMonitor {
  static let shared = NetworkMonitor()

  let monitor = NWPathMonitor()
  private var status: NWPath.Status = .requiresConnection
  var isReachable: Bool { status == .satisfied }
  var isReachableOnCellular: Bool = true

  func startMonitoring() {
    monitor.pathUpdateHandler = { [weak self] path in
      self?.status = path.status
      self?.isReachableOnCellular = path.isExpensive

      if path.status == .satisfied && path.isExpensive == false {
        HogLogger.log(category: .default).info("Connected to a network")
      } else {
        HogLogger.log(category: .default).info("Not connected to a network")
      }
    }

    let queue = DispatchQueue(label: "NetworkMonitor")
    monitor.start(queue: queue)
  }

  func stopMonitoring() {
    monitor.cancel()
  }
}
