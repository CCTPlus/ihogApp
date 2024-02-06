//
//  OSCConfigView.swift
//  iHog
//
//  Created by Jay on 2/6/24.
//

import SwiftUI

struct OSCConfigView: View {
  @State private var isOSCEnabled = false
  @State private var consoleIPAddress = ""
  @State private var inputPort = ""
  @State private var outputPort = ""
  var body: some View {
    Form {
      Toggle("Enable OSC", isOn: $isOSCEnabled)
      Section {
        TextField("IP Address", text: $consoleIPAddress)
        TextField("Input Port", text: $inputPort)
        TextField("Output Port", text: $outputPort)
      } header: {
        Text("Console")
      } footer: {
        Text("Match what's listed in the labels on the console")
      }

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
          print("DO THIS ONCE ABLE")
        }
        .disabled(isOSCEnabled == false)
      } footer: {
        Text("Open the console's log and see `/hog/test/0/` be received")
      }
    }
  }
}

#Preview {
  OSCConfigView()
}
