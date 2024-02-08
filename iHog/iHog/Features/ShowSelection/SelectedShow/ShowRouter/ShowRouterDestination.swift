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

  case programming, playback, hardwarePlayback, hardwarePlayProg, hardwareProg

  var title: LocalizedStringKey {
    switch self {
      case .programming:
        "ShowTab.programming"
      case .playback:
        "ShowTab.playback"
      case .hardwarePlayback:
        "ShowTab.hardwarePlayback"
      case .hardwarePlayProg:
        "ShowTab.hardwarePlayProg"
      case .hardwareProg:
        "ShowTab.hardwareProg"
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
      case .hardwarePlayProg:
        "cpu"
      case .hardwareProg:
        "paintbrush"
    }
  }

  func label(isSelected: Bool = false) -> some View {
    Label(self.title, systemImage: isSelected ? "checkmark" : self.icon)
  }

  @ViewBuilder
  var view: some View {
    switch self {
      case .programming:
        ProgrammerView()
      case .playback:
        PlaybackHardwareView()
      case .hardwarePlayback:
        Text(title)
      case .hardwarePlayProg:
        Text(title)
      case .hardwareProg:
        Text(title)
    }
  }
}
