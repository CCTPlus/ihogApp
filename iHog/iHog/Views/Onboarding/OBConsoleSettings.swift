//
//  OBConsoleSettings.swift
//  iHog
//
//  Created by Jay Wilson on 2/14/22.
//

import SwiftUI

struct OBConsoleSettings: View {
    @EnvironmentObject var osc: OSCHelper

    @Binding var currentStep: Int

    @State private var consoleIP = ""
    @State private var inputPort = ""
    @State private var outputPort = ""

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("iHog uses Open Sound Control to control and receive feedback")
            Text("Let’s connect to your console for the first time.")
            Text("If you aren’t ready to connect, then hit the skip button to go directly into the app")
                .foregroundColor(.gray)
                .font(.subheadline)
            Text("Open your *Open Sound Control* settings on the console and input the information here")
            Spacer()
            GroupBox {
                TextField("Console HogNet IP Address", text: $consoleIP)
                    .textFieldStyle(.roundedBorder)
                TextField("Console Input Port", text: $inputPort)
                    .textFieldStyle(.roundedBorder)
                TextField("Console Output Port", text: $outputPort)
                    .textFieldStyle(.roundedBorder)
            }
            Spacer()
            HStack {
                Spacer()
                Button("Get Device Information") {
                    #if targetEnvironment(simulator)
                    currentStep += 1
                    #else
                    osc.setConsoleSettings(ip: consoleIP,
                                           inputPort: Int(inputPort) ?? 7001,
                                           outputPort: Int(outputPort) ?? 7002,
                                           useTCP: false)
                    currentStep += 1
                    #endif
                }.padding()
                    .foregroundColor(.white)
                    .background(RoundedRectangle(cornerRadius: 10.0)
                                    .fill(Color.blue))
                Spacer()
            }
        }.padding()
    }
}

struct OBConsoleSettings_Previews: PreviewProvider {
    @State static var currentStep = 2
    @State static var settings = SettingsNav.device
    
    static var previews: some View {
        OnboardingView(currentStep: 2, setting: $settings)
    }
}
