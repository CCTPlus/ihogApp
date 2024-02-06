//
//  RouterDestination.swift
//  iHog
//
//  Created by Jay on 1/21/24.
//

import Foundation

enum RouterDestination: Hashable {
  case show(UUID)
  case wishkit
  case oscConfiguration
  case oscLog
}
