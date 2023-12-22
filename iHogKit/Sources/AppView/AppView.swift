// AppView.swift
//
//
//
// Follow Jay on mastodon @heyjay@iosdev.space
//               threads  @heyjaywilson
//               github   @heyjaywilson
//               website  cctplus.dev

import AppInfoCore
import AppInfoView
import ComposableArchitecture
import SwiftUI

public struct AppView: View {
    let appInfoStore: StoreOf<AppInfoFeature>
    public init(appInfoStore: StoreOf<AppInfoFeature>) {
        self.appInfoStore = appInfoStore
    }

    public var body: some View {
        NavigationSplitView {
            List {
                Section {
                    Text("Programmer")
                    Text("Playback")
                }

                Section {
                    Text("Show one")
                    Text("Show two")
                    Text("Show three")
                } header: {
                    Text("Shows")
                }

                Section {
                    Text("OSC Settings")
                    Text("Programmer Settings")
                    Text("Show Settings")
                }

                AppInfoView(store: appInfoStore)

                Text("Made with ☕ in Austin, Tx")
                    .multilineTextAlignment(.center)
                    .foregroundStyle(.secondary)
                    .frame(maxWidth: .infinity)
                    .listRowBackground(Color.clear)
            }
        } detail: {
            Text("Hello")
        }

    }
}

#Preview {
    AppView(
        appInfoStore: Store(initialState: AppInfoFeature.State()) {
            AppInfoFeature()
        }
    )
}
