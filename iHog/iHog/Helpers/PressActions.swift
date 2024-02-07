//
//  PressActions.swift
//  iHog
//
//  Created by Jay on 2/7/24.
//

import Foundation
import SwiftUI

struct PressActions: ViewModifier {
  var onPress: () -> Void
  var onRelease: () -> Void

  func body(content: Content) -> some View {
    content
      .simultaneousGesture(
        DragGesture(minimumDistance: 0)
          .onChanged({ _ in
            onPress()
          })
          .onEnded({ _ in
            onRelease()
          })
      )
  }
}

extension View {
  func pressActions(onPress: @escaping (() -> Void), onRelease: @escaping (() -> Void)) -> some View
  {
    modifier(
      PressActions(
        onPress: {
          onPress()
        },
        onRelease: {
          onRelease()
        }
      )
    )
  }
}
