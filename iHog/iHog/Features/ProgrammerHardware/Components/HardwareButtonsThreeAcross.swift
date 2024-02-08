//
//  FunctionKeysView.swift
//  iHog
//
//  Created by Jay on 2/7/24.
//

import SwiftUI

struct HardwareButtonsThreeAcross: View {
  @Environment(OSCManager.self) var oscManager

  let keys: [HogKey]

  var body: some View {
    LazyVGrid(columns: GridConstant.threeColumn) {
      ForEach(keys) { key in
        HardwareButton(key: key)
      }
    }
  }
}

#Preview {
  HardwareButtonsThreeAcross(keys: HogKey.functionKeys)
    .environment(OSCManager(outputPort: 1000, consoleInputPort: 1000))
}
