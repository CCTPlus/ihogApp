//
//  ObjectButtonView.swift
//  iHog
//
//  Created by Jay Wilson on 9/24/20.
//

import SwiftUI

struct ObjectButtonView: View {
  var body: some View {
    VStack(spacing: 1) {
      HStack(spacing: 1) {
        FPButton(buttonText: "Live", buttonFunction: ButtonFunctionNames.live)
        FPButton(buttonText: "Scene", buttonFunction: ButtonFunctionNames.scene)
        FPButton(buttonText: "Cue", buttonFunction: ButtonFunctionNames.cue)
      }
      HStack(spacing: 1) {
        FPButton(buttonText: "Macro", buttonFunction: ButtonFunctionNames.macro)
        FPButton(buttonText: "List", buttonFunction: ButtonFunctionNames.list)
        FPButton(buttonText: "Page", buttonFunction: ButtonFunctionNames.page)
      }
    }
  }
}

struct ObjectButtonView_Previews: PreviewProvider {
  static var previews: some View {
    ObjectButtonView()
  }
}
