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

import HogEnvironment
import HogUtilities
import SwiftUI

/// Configures OSC
struct OpenSoundControlConfigView: View {
  @AppStorage(
    AppSetting.consoleIP.rawValue
  ) var consoleIP = AppSetting.consoleIP.defaultValue as! String
  @AppStorage(
    AppSetting.serverPort.rawValue
  ) var serverPort: String = AppSetting.serverPort.defaultValue as! String
  @AppStorage(
    AppSetting.clientPort.rawValue
  ) var clientPort: String = AppSetting.clientPort.defaultValue as! String
  @AppStorage(
    AppSetting.isOSCOn.rawValue
  ) var isOSCOn = AppSetting.isOSCOn.defaultValue as! Bool
  @AppStorage(
    AppSetting.selectedInterfaceName.rawValue
  ) var selectedInterfaceName = AppSetting.selectedInterfaceName.defaultValue as! String

  @State var viewModel = OpenSoundControlConfigViewModel()

  var body: some View {
    VStack {
      Group {
        deviceSettings
        consoleSettings
        interfaceSelection
        buttons
      }
      .padding()
      .background(.ultraThickMaterial)
      .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
      .padding(.vertical, 4)
    }
    .padding()
  }

  @ViewBuilder
  var interfaceSelection: some View {
    VStack(alignment: .leading) {
      HStack {
        Text("Network Interface")
        Spacer()
        Picker("Network", selection: $selectedInterfaceName) {
          ForEach(viewModel.availableInterfaces) { interface in
            Text(interface.displayName)
              .tag(interface.name)
          }
        }
        .pickerStyle(.menu)
      }
      .task {
        if let firstInterface = viewModel.availableInterfaces.first {
          selectedInterfaceName = firstInterface.name
        }
      }
    }
  }

  @ViewBuilder
  var deviceSettings: some View {
    VStack(alignment: .leading, spacing: 8) {
      HStack {
        Text("This Device")
          .font(.headline)
        Spacer()
      }
      HStack {
        Text("IP Address")
        Spacer()
        Text("192.168.0.1")
      }
      Text("You cannot change this from iHog.")
        .font(.footnote)
        .foregroundStyle(.secondary)
    }
    .frame(maxWidth: .infinity, alignment: .leading)
  }

  @ViewBuilder
  var consoleSettings: some View {
    VStack(alignment: .leading, spacing: 8) {
      HStack {
        Text("Console")
          .font(.headline)
        Spacer()
      }
      HStack {
        Text("IP Address")
        Spacer()
        TextField("IP Address", text: $consoleIP)
          .textFieldStyle(.roundedBorder)
          .multilineTextAlignment(.trailing)
          .frame(maxWidth: 200)
      }
      HStack {
        Text("Input Port")
        Spacer()
        TextField("Input Port", text: $serverPort)
          .textFieldStyle(.roundedBorder)
          .multilineTextAlignment(.trailing)
          .frame(maxWidth: 100)
      }
      HStack {
        Text("Output Port")
        Spacer()
        TextField("Output Port", text: $clientPort)
          .textFieldStyle(.roundedBorder)
          .multilineTextAlignment(.trailing)
          .frame(maxWidth: 100)
      }
    }
    .frame(maxWidth: .infinity, alignment: .leading)
  }

  @ViewBuilder var buttons: some View {
    HStack {
      Button("Save Settings") {
        //TODO: IMPLEMENT SAVE Settings
        fatalError("Implement")
      }
      Spacer()
      Button("Connect") {
        //TODO: IMPLEMENT SAVE Settings
        fatalError("Implement")
      }
      .buttonStyle(.borderedProminent)
      .tint(.green)
    }
  }
}

#Preview("No interfaces") {
  OpenSoundControlConfigView()
}
#Preview("Has interfaces") {
  OpenSoundControlConfigView(
    viewModel: OpenSoundControlConfigViewModel(
      availableInterfaces: NetworkInterface.mockInterfaces
    )
  )
}
