//
//  KindKeysView.swift
//  iHog
//
//  Created by Jay on 2/6/24.
//

import SwiftUI

struct KindKeysView: View {
  @Environment(OSCManager.self) var oscManager
  @State private var buttonHeight: CGFloat = 0

  let keys: [HogKey] = [.intensity, .position, .color, .beam, .effect, .time, .group, .fixture]

  let cols = [
    GridItem(.flexible(minimum: 70), spacing: 8, alignment: .leading),
    GridItem(.flexible(minimum: 70), spacing: 8, alignment: .leading),
    GridItem(.flexible(minimum: 70), spacing: 8, alignment: .leading),
    GridItem(.flexible(minimum: 70), spacing: 8, alignment: .leading),
  ]

  var body: some View {
    LazyVGrid(columns: cols) {
      ForEach(keys) { key in
        Button {
          do {
            try oscManager.push(button: key)
          } catch {
            print(error)
          }
        } label: {
          key.label
            .frame(maxWidth: .infinity)
            .frame(height: buttonHeight)
            .widthChangePreference(completion: { width in
              buttonHeight = width
            })
        }
        .buttonStyle(.borderedProminent)
        .tint(.secondary)
      }
    }
  }
}

#Preview {
  KindKeysView()
    .environment(OSCManager(outputPort: 7002, consoleInputPort: 2000))
}
