//
//  OSCSettings.swift
//  iHog
//
//  Created by Jay Wilson on 3/24/21.
//

import Network
import SwiftUI

struct OSCSettings: View {
  @EnvironmentObject var osc: OSCHelper

  @State private var availableInterfaces: [NetworkInterface] = []

  @AppStorage("selectedInterfaceName") private var selectedInterfaceName: String = ""

  @AppStorage(AppStorageKey.consoleIP.rawValue) var consoleIP: String = "172.31.0.1"
  @AppStorage(AppStorageKey.serverPort.rawValue) var serverPort: String = "7001"
  @AppStorage(AppStorageKey.clientPort.rawValue) var clientPort: String = "7002"
  @AppStorage(AppStorageKey.isOSCOn.rawValue) var isOSCOn: Bool = false

  var body: some View {
    Form {
      if availableInterfaces.isEmpty {
        Text(
          "You do not have any network connections available. Please connect your device to the same network as your console."
        )
      }
      Section {
        Picker("Network Interface", selection: $selectedInterfaceName) {
          ForEach(availableInterfaces) { interface in
            Text(interface.displayName)
              .tag(interface.name)
          }
        }

        HStack {
          Text("This device's IP Address")
          Spacer()
          Text(selectedInterfaceIP).foregroundColor(.secondary)
        }

        HStack {
          Text("Console HogNet IP Address")
          Spacer()
          TextField("Console HogNet IP Address", text: $consoleIP)
            .multilineTextAlignment(.trailing)
        }
        HStack {
          Text("Console Input Port")
          Spacer()
          TextField("Console HogNet IP Address", text: $serverPort)
            .multilineTextAlignment(.trailing)
        }
        HStack {
          Text("Console Output Port")
          Spacer()
          TextField("Console HogNet IP Address", text: $clientPort)
            .multilineTextAlignment(.trailing)
        }
      }

      Section {
        Button {
          isOSCOn
            ? Analytics.shared.logEvent(with: .disconnectFromConsoleTapped)
            : Analytics.shared.logEvent(with: .connectToConsoleTapped)
          isOSCOn ? stopOSC() : startOSC()
        } label: {
          Text(isOSCOn ? "Disconnect" : "Connect to Console")
        }
      }
      OSCLogView()

    }
    .disabled(availableInterfaces.isEmpty)
    .task {
      await loadNetworkInterfaces()
      // Only start osc if there's a connection that can be made
      if isOSCOn && availableInterfaces.isEmpty == false {
        startOSC()
      } else {
        stopOSC()
      }
    }
  }

  private var selectedInterfaceIP: String {
    guard let interface = availableInterfaces.first(where: { $0.name == selectedInterfaceName })
    else {
      return "Select an interface"
    }
    return interface.address
  }

  private func loadNetworkInterfaces() async {
    availableInterfaces = NetworkInterface.getAllInterfaces()
    if selectedInterfaceName.isEmpty && !availableInterfaces.isEmpty {
      selectedInterfaceName = availableInterfaces[0].name
    }
  }

  func startOSC() {
    osc.setConsoleSettings(
      ip: consoleIP,
      inputPort: Int(serverPort) ?? 7001,
      outputPort: Int(clientPort) ?? 7002,
      interface: selectedInterfaceName
    )
    osc.startServer()
    osc.send("/hog/ihog/is/connected/")
    if osc.oscErrorOccured {
      isOSCOn = false
    } else {
      isOSCOn = true
    }
  }

  func stopOSC() {
    osc.stopServer()
    isOSCOn = false
  }
}

struct NetworkInterface: Identifiable {
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
          let address = String(cString: hostname)
          interfaces.append(
            NetworkInterface(name: name, displayName: displayName, address: address)
          )
        }
      }
    }

    return interfaces
  }
}

//struct OSCSettings_Previews: PreviewProvider {
//    static var previews: some View {
//        OSCSettings()
//    }
//}
