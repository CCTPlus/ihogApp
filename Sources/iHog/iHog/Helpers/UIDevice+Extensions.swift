//
//  File.swift
//  iHog
//
//  Created by Jay Wilson on 9/17/20.
//

import Foundation
import UIKit

extension UIDevice {

  private struct InterfaceNames {
    static let wifi = ["en0"]
    static let wired = ["en2", "en3", "en4"]
    static let cellular = ["pdp_ip0", "pdp_ip1", "pdp_ip2", "pdp_ip3"]
    static let supported = wifi + wired
  }

  func ipAddress() -> String? {
    var ipAddress: String?
    var ifaddr: UnsafeMutablePointer<ifaddrs>?

    if getifaddrs(&ifaddr) == 0 {
      var pointer = ifaddr

      while pointer != nil {
        defer { pointer = pointer?.pointee.ifa_next }

        guard
          let interface = pointer?.pointee,
          interface.ifa_addr.pointee.sa_family == UInt8(AF_INET),
          let interfaceName = interface.ifa_name,
          let interfaceNameFormatted = String(cString: interfaceName, encoding: .utf8),
          InterfaceNames.supported.contains(interfaceNameFormatted)
        else { continue }

        var hostname = [CChar](repeating: 0, count: Int(NI_MAXHOST))

        getnameinfo(
          interface.ifa_addr,
          socklen_t(interface.ifa_addr.pointee.sa_len),
          &hostname,
          socklen_t(hostname.count),
          nil,
          socklen_t(0),
          NI_NUMERICHOST
        )

        guard
          let formattedIpAddress = String(cString: hostname, encoding: .utf8),
          !formattedIpAddress.isEmpty
        else { continue }

        ipAddress = formattedIpAddress
        break
      }

      freeifaddrs(ifaddr)
    }

    return ipAddress
  }

}
