//
//  PressAction.swift
//  iHog
//
//  Created by Jay Wilson on 3/9/21.
//

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
