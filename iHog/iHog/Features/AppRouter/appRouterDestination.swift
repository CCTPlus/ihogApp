//
//  AppRouterDestination.swift
//  iHog
//
//  Created by Jay on 1/21/24.
//

import SwiftUI
import WishKit

extension View {
  func appRouterDestination() -> some View {
    navigationDestination(for: RouterDestination.self) { destination in
      switch destination {
        case let .show(showID):
          SelectedShowView(showID: showID)
        case .wishkit:
          WishKit.view
        case .oscConfiguration:
          OSCConfigView()
        case .oscLog:
          Text("OSC Log")
      }
    }
  }
}
