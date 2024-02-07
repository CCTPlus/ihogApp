//
//  OSCConfigView.swift
//  iHog
//
//  Created by Jay on 2/6/24.
//

import OSLog
import SwiftUI

struct OSCConfigView: View {
  @AppStorage(UserDefaultKey.isOSCEnabled.rawValue) var isOSCEnabled = false
  @AppStorage(UserDefaultKey.consoleIP.rawValue) var consoleIPAddress = "172.31.0.1"
  @AppStorage(UserDefaultKey.clientPort.rawValue) var inputPort = "7001"
  @AppStorage(UserDefaultKey.serverPort.rawValue) var outputPort = "7002"

  @Environment(OSCManager.self) var oscManager

  var disableTextFields: Bool {
    isOSCEnabled == true
  }

  var disableTestButton: Bool {
    isOSCEnabled == false
  }

  var body: some View {
    Form {
      Toggle("Enable OSC", isOn: $isOSCEnabled)
      Section {
        TextField("IP Address", text: $consoleIPAddress)
          .keyboardType(.decimalPad)
          .disabled(disableTextFields)
        TextField("Input Port", text: $inputPort)
          .keyboardType(.decimalPad)
          .disabled(disableTextFields)
        TextField("Output Port", text: $outputPort)
          .keyboardType(.decimalPad)
          .disabled(disableTextFields)
      } header: {
        Text("Console")
      } footer: {
        Text("Match what's listed in the labels on the console")
      }
      .foregroundStyle(disableTextFields ? .secondary : .primary)

      Section {
        HStack {
          Text("IP Address")
          Spacer()
          Text(IPHelper.getWifiIP())
            .foregroundStyle(.secondary)
        }
      } header: {
        Text("This device")
      } footer: {
        Text("This is what you should put into the Output IP address")
      }

      Section {
        Button("Send test signal") {
          do {
            try oscManager.sendTestMessage()
            Logger.osc.debug("Sent message")
          } catch {
            Logger.osc.error("\(error)")
          }
        }
        .disabled(disableTestButton)
      } footer: {
        Text("Open the console's log and see `/hog/test/0/` be received")
      }
    }
    .onChange(of: isOSCEnabled) {
      if isOSCEnabled {
        configureOSC()
      }
      do {
        try oscManager.toggleOSC()
      } catch {
        Logger.osc.error("\(error)")
      }
    }
  }

  func configureOSC() {
    oscManager.configureServer(with: Int(outputPort)!)
    oscManager.configureConsoleInformation(port: Int(inputPort)!, ipAddress: consoleIPAddress)
  }
}

#Preview {
  OSCConfigView()
    .environment(OSCManager(outputPort: 1900, consoleInputPort: 1901))
}
