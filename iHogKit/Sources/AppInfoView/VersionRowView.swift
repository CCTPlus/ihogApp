// VersionRowView.swift
//
//
//
// Follow Jay on mastodon @heyjay@iosdev.space
//               threads  @heyjaywilson
//               github   @heyjaywilson
//               website  cctplus.dev

import AppInfoCore
import ComposableArchitecture
import SwiftUI

struct VersionRowView: View {
    let store: StoreOf<AppInfoFeature>
    var body: some View {
        WithViewStore(self.store, observe: { $0.version }) { viewStore in
            Text(viewStore.state)
                .font(.monospaced(.body)())
                .onAppear { viewStore.send(.versionViewLoaded) }
        }
    }
}

#Preview {
    List {
        VersionRowView(
            store: Store(initialState: AppInfoFeature.State()) {
                AppInfoFeature()
            }
        )
    }
}
