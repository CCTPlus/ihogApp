//
//  ShowTabs.swift
//  AppRouter
//
//  Created by Jay Wilson on 1/3/25.
//

public enum ShowTab: Hashable {
  /// group and pallettes
  case programmingObjects
  /// Scenes and lists
  case playbackObjects
  /// programming objects with programming hardware
  case puntPageProgramming
  /// playback objects with playback hardware
  case puntPagePlayback
  /// playback hardware and programming objects
  case puntPageMix

  public var label: String {
    switch self {
      case .programmingObjects: "Program"
      case .playbackObjects: "Playback"
      case .puntPageMix: "Punt 3"
      case .puntPagePlayback: "Punt 1"
      case .puntPageProgramming: "Punt 2"
    }
  }

  public var systemName: String {
    switch self {
      case .programmingObjects: "paintpalette"
      case .playbackObjects: "play.rectangle"
      case .puntPageProgramming:
        "esim"
      case .puntPagePlayback:
        "slider.horizontal.below.square.filled.and.square"
      case .puntPageMix:
        "slider.horizontal.2.square"
    }
  }

  public var analyticsName: String {
    switch self {
      case .programmingObjects: "Programming"
      case .playbackObjects: "Playback"
      case .puntPageMix: "Punt Page Mix"
      case .puntPagePlayback: "Punt Page Playback"
      case .puntPageProgramming: "Punt Page Programming"
    }
  }
}
