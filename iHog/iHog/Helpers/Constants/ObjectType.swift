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
}
