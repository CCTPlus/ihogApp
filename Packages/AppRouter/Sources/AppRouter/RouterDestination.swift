//
//  RouterDestination.swift
//  AppRouter
//
//  Created by Jay Wilson on 12/10/24.
//

import Foundation

public enum RouterDestination: Hashable {
  case show(UUID)
  case osc
  case programmer
  case playback
  case programmerSettings
  case showSettings
  case appFeedback
}
