//
//  PhoneProgrammerView.swift
//  iHog
//
//  Created by Jay on 2/6/24.
//

import SwiftUI

struct PhoneProgrammerView: View {
  @Environment(OSCManager.self) var oscManager

  var body: some View {
    VStack(spacing: 24) {
      Text(oscManager.commandLine)
      Spacer()
      HardwareButtonsFourAcross(keys: HogKey.kindKeys)
      KeypadView()
    }
    .padding()
  }
}

#Preview {
  NavigationStack {
    PhoneProgrammerView()
      .navigationTitle("Hello")
      .navigationBarTitleDisplayMode(.inline)
      .environment(OSCManager(outputPort: 9001, consoleInputPort: 9002))
  }
}
