//
//  SwiftUIView.swift
//  Features
//
//  Created by Jay Wilson on 11/27/24.
//

import DesignSystem
import Router
import Settings
import SwiftUI

struct AppTabView: View {
  @Environment(Router.self) var router
  var body: some View {
    VStack(spacing: 0) {
      HeaderView(isConnectedOSC: false)
        .hidden()
      switch router.selectedTab {
        case .playback:
          Text("Playback")
        case .programming:
          Text("Programming")
        case .puntPage:
          Text("Punt Page")
        case .settings:
          SettingsView()
      }
    }
    .background(Material.bar)
  }
}

#Preview {
  AppTabView()
    .environment(Router())
}
