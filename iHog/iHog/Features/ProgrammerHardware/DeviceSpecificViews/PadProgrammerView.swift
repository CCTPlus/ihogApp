//
//  PadProgrammerView.swift
//  iHog
//
//  Created by Jay on 2/7/24.
//

import SwiftUI

struct PadProgrammerView: View {
  @Environment(OSCManager.self) var oscManager
  var body: some View {
    VStack(spacing: 24) {
      Text(oscManager.commandLine)
      Spacer()
      HStack(spacing: 24) {
        EncoderWheel(wheelNumber: 1)
        EncoderWheel(wheelNumber: 2)
        EncoderWheel(wheelNumber: 3)
        EncoderWheel(wheelNumber: 4)
        EncoderWheel(wheelNumber: 5)

      }
      .padding(.horizontal)
      .frame(maxHeight: 160.0)
      HStack(alignment: .bottom) {
        VStack(spacing: 24) {
          HardwareButtonsThreeAcross(keys: HogKey.objectKeys)
          HardwareButtonsThreeAcross(keys: HogKey.actionKeys)
          HardwareButtonsThreeAcross(keys: HogKey.utilityKeys)
        }
        VStack(spacing: 24) {
          HardwareButtonsFourAcross(keys: HogKey.kindKeys)
          KeypadView()
        }
        VStack(spacing: 24) {
          HardwareButtonsThreeAcross(keys: HogKey.hbc)
          HardwareButtonsThreeAcross(keys: HogKey.selectKeys)
          HardwareButtonsThreeAcross(keys: HogKey.functionKeys)
        }
      }
    }
  }
}

#Preview {
  PadProgrammerView()
    .environment(OSCManager(outputPort: 9001, consoleInputPort: 9002))
}
