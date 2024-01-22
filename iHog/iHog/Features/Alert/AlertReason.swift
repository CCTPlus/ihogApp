//
//  AlertReason.swift
//  iHog
//
//  Created by Jay on 1/21/24.
//

import Foundation
import SwiftUI

enum AlertAction {
  case okay
  case cancel

  var localizedStringKey: LocalizedStringKey {
    switch self {
      case .okay:
        "Alert.button.okay"
      case .cancel:
        "Alert.button.cancel"
    }
  }
}

enum AlertReason: Hashable {
  case couldNotSaveShow

  var title: LocalizedStringKey {
    switch self {
      case .couldNotSaveShow:
        "Alert.title.couldNotSaveShow"
    }
  }

  var action: AlertAction {
    switch self {
      case .couldNotSaveShow:
        return .okay
    }
  }
}
