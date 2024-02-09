//
//  ProgrammerScreen.swift
//  iHog
//
//  Created by Jay on 2/7/24.
//

import SwiftUI

struct ProgrammerScreen: View {
  @Environment(OSCManager.self) var oscManager
  var body: some View {
    switch UIDevice.current.userInterfaceIdiom {
      case .pad:
        PadProgrammerView()
      case .phone:
        PhoneProgrammerView()
      default:
        PhoneProgrammerView()
    }
  }
}

#Preview {
  ProgrammerScreen()
    .environment(OSCManager(outputPort: 1000, consoleInputPort: 1000))
}
