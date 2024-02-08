//
//  PlaybackBar.swift
//  iHog
//
//  Created by Jay on 2/7/24.
//

import SwiftUI

struct PlaybackBar: View {
  var masterNumber: Int

  @State private var slider = 0.0

  var body: some View {
    VStack(spacing: 12) {
      HardwareButton(key: .pbChoose, masterNumber: masterNumber)
      HardwareButton(key: .pbGo, masterNumber: masterNumber)
      HardwareButton(key: .pbHalt, masterNumber: masterNumber)
      HardwareButton(key: .pbBack, masterNumber: masterNumber)

      Slider(value: $slider)
        .rotationEffect(Angle(degrees: -90))
        .frame(width: 200, height: 200)
      HardwareButton(key: .flash, masterNumber: masterNumber)
    }
    .frame(width: 100)
  }
}

#Preview {
  ScrollView {
    HStack {
      PlaybackBar(masterNumber: 100)
      PlaybackBar(masterNumber: 1)
    }
  }
  .environment(OSCManager(outputPort: 7001, consoleInputPort: 7002))
}
