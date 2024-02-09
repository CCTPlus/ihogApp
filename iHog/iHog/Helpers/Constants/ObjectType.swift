//
//  ObjectType.swift
//  iHog
//
//  Created by Jay on 2/9/24.
//

import Foundation
import SwiftUI

enum ObjectType: String, CaseIterable, Identifiable {
  var id: String {
    self.rawValue
  }

  case group
  case intensity
  case position
  case color
  case beam
  case effect
  case list
  case scene

  var label: String {
    return self.rawValue.capitalized
  }

  var hogKey: HogKey? {
    switch self {
      case .group:
        HogKey.group
      case .intensity:
        HogKey.intensity
      case .position:
        HogKey.position
      case .color:
        HogKey.color
      case .beam:
        HogKey.beam
      case .effect:
        HogKey.effect
      case .list, .scene:
        nil
    }
  }

  var pressAddress: String {
    switch self {
      case .list:
        "/hog/playback/go/0"
      case .scene:
        "/hog/playback/go/1/"
      default:
        hogKey!.oscAddress()
    }
  }
}
