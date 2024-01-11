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
                    ShowRow(
                        show,
                        { viewStore.send(.deleteButtonTapped(id: show.id)) },
                        { print("implement launch action")}
                    )
                }
            } header: {
                header({ viewStore.send(.addButtonTapped) })
            }
            .sheet(
                store: self.store.scope(
                    state: \.$destination.addShow,
                    action: \.destination.addShow
                )
            ) { store in
                NavigationStack {
                    AddShowView(store: store)
                }
            }
            .alert(
                store: self.store.scope(state: \.$destination.alert, action: \.destination.alert)
            )
        }
    }

    @ViewBuilder
    func header(_ addShow: @escaping () -> Void) -> some View {
        HStack {
            Text("Shows")
            Spacer()
            Button { addShow() } label: {
                Image(systemName: "folder.badge.plus")
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
