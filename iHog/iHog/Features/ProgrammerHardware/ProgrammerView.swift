//
//  ProgrammerView.swift
//  iHog
//
//  Created by Jay on 2/6/24.
//

import SwiftUI

struct ProgrammerView: View {
  @Environment(OSCManager.self) var oscManager

  var body: some View {
    VStack(spacing: 24) {
      Text(oscManager.commandLine)
      Spacer()
      KindKeysView()
      KeypadView()
    }
    .padding()
  }
}

#Preview {
  NavigationStack {
    ProgrammerView()
      .navigationTitle("Hello")
      .navigationBarTitleDisplayMode(.inline)
      .environment(OSCManager(outputPort: 9001, consoleInputPort: 9002))
  }
}
