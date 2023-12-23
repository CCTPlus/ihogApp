// SwiftUIView.swift
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

public struct ShowsView: View {
    let store: StoreOf<ShowsFeature>

    public init(
        store: StoreOf<ShowsFeature> = Store(initialState: ShowsFeature.State()) {
            ShowsFeature()
        }
    ) {
        self.store = store
    }

    public var body: some View {
        WithViewStore(self.store, observe: \.shows) { viewStore in
            Section {
                ForEach(viewStore.state) { show in
                    Text(show.name)
                }
            } header: {
                HStack {
                    Text("Shows")
                    Spacer()
                    Button {
                        viewStore.send(.addButtonTapped)
                    } label: {
                        Image(systemName: "folder.badge.plus")
                    }
                }
            }
            .sheet(store: self.store.scope(state: \.$addShow, action: \.addShow)) { store in
                NavigationStack {
                    AddShowView(store: store)
                }
            }
        }
    }
}

#Preview {
    List {
        ShowsView(
            store: Store(
                initialState: ShowsFeature.State(
                    shows: [
                        Show(id: UUID(), name: "The Eras Tour"),
                        Show(id: UUID(), name: "HeyJayWilson.live"),
                        Show(id: UUID(), name: "The Lion King"),
                    ]
                )
            ) { ShowsFeature() }
        )
    }
}
