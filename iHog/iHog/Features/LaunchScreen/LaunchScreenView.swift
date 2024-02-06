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
  @Environment(NetworkManager.self) var network
  @State private var router = Router()
  @State private var alertManager = AlertManager()

  var body: some View {
    NavigationStack(path: $router.path) {
      List {
        Section {
          SubscriptionRow(isSubscribed: userLevelManager.userLevel == .pro)
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
          case .paywall:
            DefaultPaywallView()
          case .subscriptionManagement:
            SubscriptionManagementView()
              .environment(userLevelManager)
              .environment(network)
        }
      }
      .appRouterDestination()
      .environment(router)
      .environment(alertManager)
    }
  }
}

#Preview("Not subscribed") {
  LaunchScreenView()
    .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    .environment(UserLevelManager(userLevel: .free))
    .environment(NetworkManager())
    .previewDisplayName("Not subscribed")
}

#Preview("Subscribed") {
  LaunchScreenView()
    .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    .environment(UserLevelManager(userLevel: .pro))
    .environment(NetworkManager())
}
