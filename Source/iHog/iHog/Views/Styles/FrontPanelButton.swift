//
//  FrontPanelButton.swift
//  iHog
//
//  Created by Jay Wilson on 10/12/21.
//

import Foundation
import SwiftUI

struct FrontPanelButton: ButtonStyle {
  var width: CGFloat
  var height: CGFloat = 65
  var backgroundColor: Color

  func makeBody(configuration: Configuration) -> some View {
    configuration.label
      .frame(
        width: width,
        height: height,
        alignment: .center
      )
      .padding(HALF_PADDING)
      .foregroundColor(.primary.opacity(configuration.isPressed ? 0.5 : 1.0))
      .background(backgroundColor)
      .scaleEffect(configuration.isPressed ? 0.9 : 1.0)
      .padding(.all, 0.5)
  }
}
