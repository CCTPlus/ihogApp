//
//  HogAlert.swift
//  iHog
//
//  Created by Jay on 1/21/24.
//

import SwiftUI

struct HogAlert: ViewModifier {
  @Environment(AlertManager.self) var alertManager

  @State private var showAlert: Bool = false

  var alertReasonKey: LocalizedStringKey {
    alertManager.alertReason?.title ?? "Alert.title.notFound"
  }

  var alertActionKey: LocalizedStringKey {
    alertManager.alertReason?.action.localizedStringKey ?? "Alert.button.notFound"
  }

  func body(content: Content) -> some View {
    content
      .onChange(of: alertManager.hasAlert) {
        showAlert = alertManager.hasAlert
      }
      .alert(alertReasonKey, isPresented: $showAlert) {
        Button(alertActionKey) {
          switch alertManager.alertReason?.action {
            case .okay:
              alertManager.dismissAlert()
            case .cancel:
              alertManager.dismissAlert()
            case nil:
              print("THIS SHOULD NOT HAPPEN")
              alertManager.dismissAlert()
          }
        }
      }
  }
}

extension View {
  func hogAlert() -> some View {
    modifier(HogAlert())
  }
}

#Preview {
  Text("Help")
    .environment(AlertManager())
    .hogAlert()
}
