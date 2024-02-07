//
//  KeypadView.swift
//  iHog
//
//  Created by Jay on 2/6/24.
//

import SwiftUI

struct KeypadView: View {
  @Environment(OSCManager.self) var oscManager
  @State private var buttonHeight: CGFloat = 0

  let keys: [HogKey] = [
    .back, .slash, .minus, .plus, .seven, .eight, .nine, .thru, .four, .five, .six, .full, .one,
    .two, .three, .at, .zero, .dot, .enter,
  ]
  let lastRow: [HogKey] = [.zero, .dot, .enter]

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
          if key == .enter {
            key.label
              .font(.largeTitle)
              .frame(width: (buttonHeight * 2) + 32, height: buttonHeight)
          } else {
            key.label
              .font(.largeTitle)
              .frame(maxWidth: .infinity)
              .frame(height: buttonHeight)
              .widthChangePreference(completion: { width in
                buttonHeight = width
              })
          }
        }
        .buttonStyle(.borderedProminent)
        .tint(.secondary)
      }
    }
  }
}

#Preview {
  KeypadView()
    .padding()
    .environment(OSCManager(outputPort: 7002, consoleInputPort: 2000))
}
