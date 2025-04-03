//
//  SFSymbols+Extensions.swift
//  iHog
//
//  Created by Jay Wilson on 8/11/22.
//

import Foundation
import SwiftUI

extension SFSymbol {
  var name: String { return rawValue }

  var image: Image { return Image(systemName: self.rawValue) }
  static let ALL_ICONS = Self.allCases
  static let NO_SHAPE_ICONS = Self.allCases.filter { !$0.name.hasSuffix("fill") }
    .filter { !$0.name.hasSuffix("circle") }.filter { !$0.name.hasSuffix("square") }
    .filter { !$0.name.contains("badge") }
}

extension Image {
  public init(symbol: SFSymbol) {
    self = Image(systemName: symbol.name)
  }
}
