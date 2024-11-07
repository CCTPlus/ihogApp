//
//  OSCSettings.swift
//  iHog
//
//  Created by Jay Wilson on 3/24/21.
//

import SwiftUI

struct OSCSettings: View {
    @EnvironmentObject var osc: OSCHelper
    
    @AppStorage(Settings.consoleIP.rawValue) var consoleIP: String = "172.31.0.1"
    @AppStorage(Settings.serverPort.rawValue) var serverPort: String = "7001"
    @AppStorage(Settings.clientPort.rawValue) var clientPort: String = "7002"
    @AppStorage(Settings.isOSCOn.rawValue) var isOSCOn: Bool = false

    var body: some View {
        Form {
            Section {
                HStack {
                    Text("This device's IP Address")
                    Spacer()
                    Text("\(UIDevice().ipAddress() ?? "IS NOT CONNECTED TO A NETWORK")").foregroundColor(.secondary)
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
                    isOSCOn ? stopOSC() : startOSC()
                } label: {
                    Text(isOSCOn ? "Disconnect" : "Connect to Console")
                }
            }
            OSCLogView()

        }.task {
                if isOSCOn {
                    startOSC()
                }
            }
    }

    func startOSC() {
        osc.setConsoleSettings(ip: consoleIP, inputPort: Int(serverPort) ?? 7001, outputPort: Int(clientPort) ?? 7002)
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

//struct OSCSettings_Previews: PreviewProvider {
//    static var previews: some View {
//        OSCSettings()
//    }
//}
