//
//  GridConstant.swift
//  iHog
//
//  Created by Jay on 2/7/24.
//

import Foundation
import SwiftUI

struct GridConstant {
  static var fourColumn: [GridItem] {
    if UIDevice.current.userInterfaceIdiom == .pad {
      return [
        GridItem(.flexible(maximum: 90), spacing: 8, alignment: .leading),
        GridItem(.flexible(maximum: 90), spacing: 8, alignment: .leading),
        GridItem(.flexible(maximum: 90), spacing: 8, alignment: .leading),
        GridItem(.flexible(maximum: 90), spacing: 8, alignment: .leading),
      ]
    } else {
      return [
        GridItem(.flexible(minimum: 70), spacing: 8, alignment: .leading),
        GridItem(.flexible(minimum: 70), spacing: 8, alignment: .leading),
        GridItem(.flexible(minimum: 70), spacing: 8, alignment: .leading),
        GridItem(.flexible(minimum: 70), spacing: 8, alignment: .leading),
      ]
    }
  }

  static var threeColumn: [GridItem] {
    if UIDevice.current.userInterfaceIdiom == .pad {
      return [
        GridItem(.flexible(maximum: 90), spacing: 8, alignment: .leading),
        GridItem(.flexible(maximum: 90), spacing: 8, alignment: .leading),
        GridItem(.flexible(maximum: 90), spacing: 8, alignment: .leading),
      ]
    } else {
      return [
        GridItem(.flexible(minimum: 70), spacing: 8, alignment: .leading),
        GridItem(.flexible(minimum: 70), spacing: 8, alignment: .leading),
        GridItem(.flexible(minimum: 70), spacing: 8, alignment: .leading),
      ]
    }
  }

  static func objectGrid(width: CGFloat) -> [GridItem] {
    return [
      GridItem(.adaptive(minimum: width, maximum: width), spacing: 12, alignment: .leading)
    ]
  }
}
