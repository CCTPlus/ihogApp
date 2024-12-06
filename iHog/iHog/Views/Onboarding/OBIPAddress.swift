//
//  OBIPAddress.swift
//  iHog
//
//  Created by Jay Wilson on 2/14/22.
//

import SwiftUI

struct OBIPAddress: View {
  @AppStorage(AppStorageKey.showOnboarding.rawValue) var showOnboarding: Bool = true
  @AppStorage(AppStorageKey.isOSCOn.rawValue) var isOSCOn: Bool = false

  @EnvironmentObject var osc: OSCHelper

  @Binding var setting: SettingsNav
  @Binding var currentStep: Int

  @State private var showPaywall = false

  var body: some View {
    VStack(alignment: .leading, spacing: 10) {
      Text("iHog uses Open Sound Control to control and receive feedback")
      Text("Let’s connect to your console for the first time.")
      Text("Open your *Open Sound Control* settings on the console and input the information here")
      Spacer()
      HStack {
        Spacer()
        VStack(alignment: .center, spacing: 30) {
          Text("Your IP Address")
            .font(.headline)
          Text("\(UIDevice().ipAddress() ?? "IS NOT CONNECTED TO A NETWORK")")
            .font(.title)
            .fontWeight(.bold)
            .foregroundColor(Color.purple)
          Text(
            "Enter this in the `Input IP Address` in the *Open Sound Control* settings on the console."
          )
          .multilineTextAlignment(.leading)
          .lineLimit(nil)
          .fixedSize(horizontal: false, vertical: true)
        }
        Spacer()
      }
      Spacer()
      HStack {
        Spacer()
        Button("Enable OSC") {
          showPaywall = true
        }
        .padding()
        .foregroundColor(.white)
        .background(
          RoundedRectangle(cornerRadius: 10.0)
            .fill(Color.green)
        )
        Spacer()
      }
      .multilineTextAlignment(.center)
      .sheet(isPresented: $showPaywall) {
        OnboardingPaywall()
          .onDisappear {
            enableOSC()
          }
      }
    }
    .padding()
  }

  func enableOSC() {
    currentStep = 4
    setting = SettingsNav.programmerHardware
    osc.startServer()
    isOSCOn = true
    showOnboarding = false
  }
}

struct OBIPAddress_Previews: PreviewProvider {
  @State static var currentStep = 3
  @State static var settings = SettingsNav.device

  static var previews: some View {
    OnboardingView(currentStep: 3, setting: $settings)
  }
}
