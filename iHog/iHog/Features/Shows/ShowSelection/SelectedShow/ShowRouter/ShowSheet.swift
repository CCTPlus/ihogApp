//
//  ShowSheet.swift
//  iHog
//
//  Created by Jay on 2/9/24.
//

import Foundation
import SwiftUI

enum ShowSheet: Int, Identifiable {
  var id: Int {
    self.rawValue
  }

  case newObject
  case encoder

  @ViewBuilder
  func view(show: ShowEntity) -> some View {
    switch self {
      case .newObject:
        NewObjectView(show: show)
      case .encoder:
        Text("Encoders")
    }
  }
}
