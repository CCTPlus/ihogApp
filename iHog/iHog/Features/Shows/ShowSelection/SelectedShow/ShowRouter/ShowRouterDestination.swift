//
//  ShowRouterDestination.swift
//  iHog
//
//  Created by Jay on 1/21/24.
//

import Foundation
import SwiftUI

enum ShowRouterDestination: Int, Identifiable, CaseIterable {
  var id: Int {
    return self.rawValue
  }

  case hardwareProg, hardwarePlayback, programming, playback

  var title: LocalizedStringKey {
    switch self {
      case .programming:
        "Groups & Palettes"
      case .playback:
        "Lists & Scenes"
      case .hardwarePlayback:
        "Playback Panel"
      case .hardwareProg:
        "Programming Panel"
    }
  }

  var icon: String {
    switch self {
      case .programming:
        "paintpalette"
      case .playback:
        "play.square"
      case .hardwarePlayback:
        "slider.horizontal.below.rectangle"
      case .hardwareProg:
        "paintbrush"
    }
  }

  func label(isSelected: Bool = false) -> some View {
    Label(self.title, systemImage: isSelected ? "checkmark" : self.icon)
  }

  @ViewBuilder
  func view(showID: UUID) -> some View {
    switch self {
      case .programming:
        ProgrammingObjectsView(showID: showID)
      case .playback:
        PlaybackObjectView(showID: showID)
      case .hardwarePlayback:
        PlaybackHardwareView()
      case .hardwareProg:
        ProgrammerScreen()
    }
  }
}
