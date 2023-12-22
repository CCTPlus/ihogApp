// AppInfoView.swift
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

public struct AppInfoView: View {
    let store: StoreOf<AppInfoFeature>
    public init(store: StoreOf<AppInfoFeature>) {
        self.store = store
    }

    public var body: some View {
        WithViewStore(self.store, observe: { $0 }) { ViewStore in
            Section {
                VersionRowView(store: store)
            } header: {
                Label("About", systemImage: "info.circle")
            }
        }
    }
}

#Preview {
    List {
        AppInfoView(
            store: Store(initialState: AppInfoFeature.State()) {
                AppInfoFeature()
            }
        )
    }
}
