//
//  KindButtonView.swift
//  iHog
//
//  Created by Jay Wilson on 9/24/20.
//

import SwiftUI

struct KindButtonView: View {
  @EnvironmentObject var osc: OSCHelper
  var body: some View {
    VStack(spacing: 1) {
      HStack(spacing: 1) {
        FPButton(
          buttonText: "Intens",
          buttonFunction: ButtonFunctionNames.intensity,
          bgColor: osc.kindKeys[.intensity]!
        )
        FPButton(
          buttonText: "Positn",
          buttonFunction: ButtonFunctionNames.position,
          bgColor: osc.kindKeys[.position]!
        )
        FPButton(
          buttonText: "Colour",
          buttonFunction: ButtonFunctionNames.colour,
          bgColor: osc.kindKeys[.colour]!
        )
        FPButton(
          buttonText: "Beam",
          buttonFunction: ButtonFunctionNames.beam,
          bgColor: osc.kindKeys[.beam]!
        )
      }
      HStack(spacing: 1) {
        FPButton(
          buttonText: "Effect",
          buttonFunction: ButtonFunctionNames.effect,
          bgColor: osc.kindKeys[.effect]!
        )
        FPButton(
          buttonText: "Time",
          buttonFunction: ButtonFunctionNames.time,
          bgColor: osc.kindKeys[.time]!
        )
        FPButton(buttonText: "Group", buttonFunction: ButtonFunctionNames.group)
        FPButton(buttonText: "Fixture", buttonFunction: ButtonFunctionNames.fixture)
      }
    }
  }
}

struct KindButtonView_Previews: PreviewProvider {
  static var previews: some View {
    KindButtonView()
  }
}
