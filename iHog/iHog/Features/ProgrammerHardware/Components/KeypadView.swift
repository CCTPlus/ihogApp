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
    .backspace, .slash, .minus, .plus, .seven, .eight, .nine, .thru, .four, .five, .six, .full,
    .one,
    .two, .three, .at, .zero, .dot, .enter,
  ]
  let lastRow: [HogKey] = [.zero, .dot, .enter]

  var body: some View {
    LazyVGrid(columns: GridConstant.fourColumn) {
      ForEach(keys) { key in
        if key == .enter {
          HardwareButton(key: key, givenButtonWidth: buttonHeight * 2)
        } else {
          HardwareButton(key: key)
            .heightChangePreference { height in
              buttonHeight = height
            }
        }
      }
    }
  }
}

#Preview {
  KeypadView()
    .padding()
    .environment(OSCManager(outputPort: 7002, consoleInputPort: 2000))
}
