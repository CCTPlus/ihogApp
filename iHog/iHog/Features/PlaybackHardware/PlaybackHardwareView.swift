//
//  PlaybackHardwareView.swift
//  iHog
//
//  Created by Jay on 2/6/24.
//

import SwiftUI

struct PlaybackHardwareView: View {
  @Environment(OSCManager.self) var oscManager
  @State private var playbackBar = 0
  var body: some View {
    VStack {
      HStack {
        HardwareButton(key: .pig)
        HardwareButton(key: .release)
        HardwareButton(key: .assert)
        HardwareButton(key: .nextPage)
      }
      .padding()
      Spacer()
      ScrollView(.horizontal) {
        HStack(spacing: 16) {
          ForEach(0..<100, id: \.self) { num in
            PlaybackBar(masterNumber: num + 1)
          }
        }
      }
      .contentMargins(20, for: .scrollContent)
    }
  }
}

#Preview {
  NavigationStack {
    PlaybackHardwareView()
      .environment(OSCManager(outputPort: 9001, consoleInputPort: 9002))
      .navigationTitle("Hello")
      .navigationBarTitleDisplayMode(.inline)
  }
}
