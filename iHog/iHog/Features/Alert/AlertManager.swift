//
//  AlertManager.swift
//  iHog
//
//  Created by Jay on 1/21/24.
//

import Foundation
import Observation
import SwiftUI

@Observable
class AlertManager {
  var hasAlert = false
  var alertReason: AlertReason?

  func showAlert(for reason: AlertReason) {
    alertReason = reason
    hasAlert = true
  }

  func dismissAlert() {
    hasAlert = false
    alertReason = nil
  }
}
