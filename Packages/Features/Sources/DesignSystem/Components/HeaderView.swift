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

  public var body: some View {
    HStack {
      Spacer()
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
      Spacer()
    }
  }
}

#Preview {
  VStack {
    HeaderView()
    Spacer()
  }
  .environment(Router())
  .modelContainer(ShowEntity.preview)
}
