//
//  LaunchScreenView.swift
//  iHog
//
//  Created by Jay on 1/20/24.
//

import RevenueCat
import SwiftUI
import WishKit

struct LaunchScreenView: View {
  @Environment(\.managedObjectContext) var moc
  @Environment(UserLevelManager.self) var userLevelManager
  @Environment(NetworkManager.self) var network
  @Environment(OSCManager.self) var oscManager
  @State private var router = Router()
  @State private var alertManager = AlertManager()

  @FetchRequest(sortDescriptors: [
    SortDescriptor(\ShowEntity.dateModified, order: .reverse)
  ])
  private var shows: FetchedResults<ShowEntity>

  init() {
    WishKit.configure(with: WishKitConstant.apiKey)
  }

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
              showNewShowForm()
            } label: {
              Image(systemName: "plus.circle")
            }
          }
        }
        Section {
          OSCSettingsSection()
        } header: {
          Text("Open Sound Control")
        }
        Section {
          ContactSection()
        } header: {
          Text("Contact")
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
      .environment(oscManager)
    }
  }

  func showNewShowForm() {
    if shows.count == 0 || userLevelManager.userLevel == .pro {
      router.show(sheet: .newShow)
    } else {
      router.show(sheet: .paywall)
    }
  }
}

#if DEBUG
  #Preview("Not subscribed") {
    LaunchScreenView()
      .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
      .environment(UserLevelManager(userLevel: .free))
      .environment(NetworkManager())
      .environment(OSCManager(outputPort: 120, consoleInputPort: 120, consoleIPAddress: ""))
  }

  #Preview("Subscribed") {
    LaunchScreenView()
      .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
      .environment(UserLevelManager(userLevel: .pro))
      .environment(NetworkManager())
      .environment(OSCManager(outputPort: 120, consoleInputPort: 120, consoleIPAddress: ""))
  }
#endif
