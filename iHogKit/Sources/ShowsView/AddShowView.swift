// AddShowView.swift
//
//
//
// Follow Jay on mastodon @heyjay@iosdev.space
//               threads  @heyjaywilson
//               github   @heyjaywilson
//               website  cctplus.dev

import ComposableArchitecture
import ShowsCore
import SwiftUI

struct AddShowView: View {
  let store: StoreOf<AddShowFeature>

  var body: some View {
    WithViewStore(self.store, observe: { $0 }) { viewStore in
      Form {
        TextField("Name", text: viewStore.binding(get: \.show.name, send: { .setName($0) }))
        Button("Save") { viewStore.send(.saveButtonTapped) }
      }
      .toolbar {
        ToolbarItem {
          Button("Cancel") {
            viewStore.send(.cancelButtonTapped)
          }
        }
      }
    }
    .navigationTitle(Text("New Show"))
  }
}

#Preview {
  NavigationStack {
    AddShowView(
      store: Store(
        initialState: AddShowFeature.State(
          show: Show(id: UUID(), name: "HeyJayWilson.live")
        )
      ) { AddShowFeature() }
    )
  }
}
