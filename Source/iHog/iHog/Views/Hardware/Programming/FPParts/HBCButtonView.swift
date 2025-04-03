//
//  HBCButtonView.swift
//  iHog
//
//  Created by Jay Wilson on 9/25/20.
//

import SwiftUI

struct HBCButtonView: View {
  @EnvironmentObject var osc: OSCHelper

  var body: some View {
    HStack(spacing: 1) {
      Button("Blind") { print("blind") }
        .pressActions(
          onPress: {
            pushButton(buttonFunction: .blind)
          },
          onRelease: {
            releaseButton(buttonFunction: .blind)
          }
        )
        .buttonStyle(FrontPanelButton(width: 65, backgroundColor: osc.blind))
      Button("High Light") { print("blind") }
        .pressActions(
          onPress: {
            pushButton(buttonFunction: .highlight)
          },
          onRelease: {
            releaseButton(buttonFunction: .highlight)
          }
        )
        .buttonStyle(FrontPanelButton(width: 65, backgroundColor: osc.highlight))
      Button("Clear") { print("Clear") }
        .pressActions(
          onPress: {
            pushButton(buttonFunction: .clear)
          },
          onRelease: {
            releaseButton(buttonFunction: .clear)
          }
        )
        .buttonStyle(FrontPanelButton(width: 65, backgroundColor: osc.clear))
    }
  }
  // MARK: Used for all buttons not a number key
  func pushButton(buttonFunction: ButtonFunctionNames) {
    osc.pushFrontPanelButton(button: buttonFunction.rawValue)
  }

  // MARK: RELEASE BUTTONS

  func releaseButton(buttonFunction: ButtonFunctionNames) {
    osc.releaseFrontPanelButton(button: buttonFunction.rawValue)
  }
}

struct HBCButtonView_Previews: PreviewProvider {
  static var previews: some View {
    HBCButtonView()
  }
}
