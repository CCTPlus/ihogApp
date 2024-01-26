//
//  LaunchScreenView.swift
//  iHog
//
//  Created by Jay on 1/20/24.
//

import SwiftUI

struct LaunchScreenView: View {
  @Environment(\.managedObjectContext) var moc
  @Environment(UserLevelManager.self) var userLevelManager
  @State private var router = Router()
  @State private var alertManager = AlertManager()

  var body: some View {
    NavigationStack(path: $router.path) {
      List {
        Section {
          if userLevelManager.userLevel == .free {
            NotSubscribedRow()
          } else {
            Text("YAYYYY")
          }
        }
        Section {
          AllShowsView()
        } header: {
          HStack {
            Text("LaunchScreenView.header.shows")
            Spacer()
            Button {
              router.show(sheet: .newShow)
            } label: {
              Image(systemName: "plus.circle")
            }
          }
        }
        Section {
          AboutSection()
        } header: {
          Text("LaunchScreenView.header.about")
        }
        InfoRow()
      }
      .navigationTitle(Text("AppTitle"))
      .sheet(item: $router.sheet) { sheet in
        switch sheet {
          case .newShow:
            ShowCreationView()
              .environment(\.managedObjectContext, moc)
              .environment(router)
              .environment(alertManager)
          case .proDetail:
            DefaultPaywallView()
        }
      }
      .appRouterDestination()
      .environment(router)
      .environment(alertManager)
    }
  }
}

#Preview {
  LaunchScreenView()
    .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    .environment(UserLevelManager(userLevel: .free))
}
