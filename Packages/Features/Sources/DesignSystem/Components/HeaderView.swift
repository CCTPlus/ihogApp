//
//  HeaderView.swift
//  Features
//
//  Created by Jay Wilson on 11/26/24.
//

import Analytics
import DataManager
import Router
import SwiftData
import SwiftUI

public struct HeaderView: View {
  @Environment(Router.self) var router
  @Query private var shows: [ShowEntity]

  var isConnectedOSC: Bool

  public init(isConnectedOSC: Bool) {
    self.isConnectedOSC = isConnectedOSC
  }

  public var body: some View {
    VStack {
      HStack {
        Spacer()
        showPicker
        Spacer()
        oscStatus
      }
      // TODO: Show errors here
    }
    .padding(.all)
    .background(Material.bar)
  }
}

#Preview {
  VStack(spacing: .Spacing.large) {
    HeaderView(isConnectedOSC: true)
    HeaderView(isConnectedOSC: false)
    Spacer()
  }
  .environment(Router())
  .modelContainer(ShowEntity.preview)
}

extension HeaderView {
  @ViewBuilder var showPicker: some View {
    Menu(router.showName ?? "Choose Show", systemImage: "chevron.up.chevron.down") {
      Section {
        ForEach(shows) { show in
          Button {
            guard let id = show.id else { return }
            router.changeShow(to: id, with: show.name)
          } label: {
            Image(systemName: show.icon ?? "folder")
            Text(show.name)
          }

        }
      }
      Section {
        Button {
          router.presentedSheet = .newShow
          Analytics.shared.logEvent(with: .addShowButtonTapped)
        } label: {
          Image(systemName: "folder.badge.plus")
          Text("Add show")
        }
      }

    }
  }

  @ViewBuilder var oscStatus: some View {
    Image(systemName: "smallcircle.filled.circle")
      .symbolRenderingMode(.hierarchical)
      .symbolVariant(.fill)
      .imageScale(.large)
      .foregroundStyle(isConnectedOSC ? .green : .red)
  }
}
