//
//  HogKey+Groups.swift
//  iHog
//
//  Created by Jay on 2/8/24.
//

import Foundation

extension HogKey {
  static let objectKeys: [HogKey] = [.live, .scene, .cue, .macro, .list, .page]
  static let utilityKeys: [HogKey] = [.setup, .goto, .set, .pig, .fan, .open]
  static let actionKeys: [HogKey] = [.delete, .move, .copy, .update, .merge, .record]
  /// Highlight, blind, and clear
  static let hbc: [HogKey] = [.highlight, .blind, .clear]
  static let selectKeys: [HogKey] = [.back, .all, .next]
  static let kindKeys: [HogKey] = [
    .intensity, .position, .color, .beam, .effect, .time, .group, .fixture,
  ]
  static let functionKeys: [HogKey] = [
    .h1, .h2, .h3, .h4, .h5, .h6, .h7, .h8, .h9, .h10, .h11, .h12,
  ]
}
