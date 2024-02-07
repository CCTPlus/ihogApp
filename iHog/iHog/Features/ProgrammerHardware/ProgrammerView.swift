//
//  ProgrammerView.swift
//  iHog
//
//  Created by Jay on 2/6/24.
//

import SwiftUI

struct ProgrammerView: View {
  var body: some View {
    VStack(spacing: 24) {
      Text("Command line text here")
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
