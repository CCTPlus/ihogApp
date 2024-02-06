//
//  View+Extensions.swift
//  iHog
//
//  Created by Jay on 1/26/24.
//

import SwiftUI

extension View {
  @ViewBuilder
  func heightChangePreference(completion: @escaping (CGFloat) -> Void) -> some View {
    self.overlay {
      GeometryReader(content: { geometry in
        Color.clear
          .preference(key: SizeKey.self, value: geometry.size.height)
          .onPreferenceChange(
            SizeKey.self,
            perform: { value in
              completion(value)
            }
          )
      })
    }
  }
}
