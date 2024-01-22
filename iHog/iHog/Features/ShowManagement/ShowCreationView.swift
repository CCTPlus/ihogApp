//
//  ShowCreationView.swift
//  iHog
//
//  Created by Jay on 1/21/24.
//

import SwiftUI

struct ShowCreationView: View {
  @Environment(\.dismiss) var dismiss
  @Environment(Router.self) var router

  @State private var showName = ""

  var showManager = ShowManager(persistenceController: .shared)

  var body: some View {
    NavigationStack {
      Form {
        TextField("ShowCreateView.showName", text: $showName)
      }
      .toolbar {
        ToolbarItem(placement: .topBarTrailing) {
          Button("ShowCreateView.save") {
            sendAction(.saveTapped)
          }
        }
        ToolbarItem(placement: .topBarLeading) {
          Button("ShowCreateView.cancel") {
            sendAction(.cancelTapped)
          }
          .tint(.red)
        }
      }
      .navigationTitle(Text("ShowCreationView.viewTitle"))
    }
  }

  private func sendAction(_ action: Action) {
    switch action {
      case .saveTapped:
        do {
          let showID = try showManager.createShow(name: showName)
          router.navigate(to: .show(showID))
          dismiss()
        } catch {
          print("Error")
        }
      case .cancelTapped:
        dismiss()
    }
  }
}

extension ShowCreationView {
  private enum Action {
    case saveTapped
    case cancelTapped
  }
}

#Preview {
  Text("Hello")
    .sheet(
      isPresented: .constant(true),
      content: {
        ShowCreationView(showManager: ShowManager(persistenceController: .preview))
          .environment(Router())
      }
    )
}
