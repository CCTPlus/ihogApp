//
// -----------------------------------------------------------
// Project: iHog
// Created on 4/4/25 by @HeyJayWilson
// -----------------------------------------------------------
// Find HeyJayWilson on the web:
// 🕸️ Website             https://heyjaywilson.com
// 💻 Follow on GitHub:   https://github.com/heyjaywilson
// 🧵 Follow on Threads:  https://threads.net/@heyjaywilson
// 💭 Follow on Mastodon: https://iosdev.space/@heyjaywilson
// ☕ Buy me a ko-fi:     https://ko-fi.com/heyjaywilson
// -----------------------------------------------------------
// Copyright© 2025 CCT Plus LLC. All rights reserved.
//

import Foundation

struct NetworkInterface: Identifiable, Equatable, Hashable {
  let id = UUID()
  let name: String  // "en0" or "en1"
  let displayName: String  // "Wi-Fi" or "Ethernet"
  let address: String

  static func getAllInterfaces() -> [NetworkInterface] {
    var interfaces: [NetworkInterface] = []

    var ifaddr: UnsafeMutablePointer<ifaddrs>?
    guard getifaddrs(&ifaddr) == 0 else {
      return []
    }
    defer { freeifaddrs(ifaddr) }

    var ptr = ifaddr
    while let interface = ptr {
      defer { ptr = interface.pointee.ifa_next }

      let flags = Int32(interface.pointee.ifa_flags)
      let addr = interface.pointee.ifa_addr.pointee
      let name = String(cString: interface.pointee.ifa_name)

      // Only include active IPv4 interfaces that are either WiFi (en0) or Ethernet (en1)
      if (flags & (IFF_UP | IFF_RUNNING)) == (IFF_UP | IFF_RUNNING)
        && addr.sa_family == UInt8(AF_INET) && (name == "en0" || name == "en1")
      {
        var hostname = [CChar](repeating: 0, count: Int(NI_MAXHOST))

        let success = getnameinfo(
          interface.pointee.ifa_addr,
          socklen_t(addr.sa_len),
          &hostname,
          socklen_t(hostname.count),
          nil,
          0,
          NI_NUMERICHOST
        )

        if success == 0 {
          let displayName = name == "en0" ? "Wi-Fi" : "Ethernet"
          let address = withUnsafeBytes(of: hostname) { bytes in
            String(bytes: bytes.prefix(while: { $0 != 0 }), encoding: .utf8) ?? ""
          }
          interfaces.append(
            NetworkInterface(name: name, displayName: displayName, address: address)
          )
        }
      }
    }

    return interfaces
  }
}

extension NetworkInterface {
  // Mock interfaces for previews and testing
  static let mockInterfaces: [NetworkInterface] = [
    NetworkInterface(
      name: "en0",
      displayName: "Wi-Fi",
      address: "192.168.1.123"
    ),
    NetworkInterface(
      name: "pdp_ip0",
      displayName: "Cellular",
      address: "172.20.10.2"
    ),
    NetworkInterface(
      name: "bridge0",
      displayName: "Personal Hotspot",
      address: "172.20.10.1"
    ),
  ]

  static var mockInterface: NetworkInterface {
    mockInterfaces[0]
  }
}
