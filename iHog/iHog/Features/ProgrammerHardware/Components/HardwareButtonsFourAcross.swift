//
//  KindKeysView.swift
//  iHog
//
//  Created by Jay on 2/6/24.
//

import SwiftUI

struct HardwareButtonsFourAcross: View {
  @Environment(OSCManager.self) var oscManager

  let keys: [HogKey]

  var body: some View {
    LazyVGrid(columns: GridConstant.fourColumn) {
      ForEach(keys) { key in
        HardwareButton(key: key)
      }
    }
  }
}

#Preview {
  HardwareButtonsFourAcross(keys: HogKey.kindKeys)
    .environment(OSCManager(outputPort: 7002, consoleInputPort: 2000))
}
