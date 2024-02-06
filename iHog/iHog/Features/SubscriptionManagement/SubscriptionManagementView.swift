//
//  SubscriptionManagementView.swift
//  iHog
//
//  Created by Jay on 2/4/24.
//

import SwiftUI

struct SubscriptionManagementView: View {
  @Environment(\.dismiss) var dismiss

  @Environment(NetworkManager.self) var network
  @Environment(UserLevelManager.self) var user

  @State private var showManageSubscriptionSheet = false

  var body: some View {
    List {
      Section {
        Text("You're a pro!")
          .font(.largeTitle)
          .bold()
        Text("Thanks for purchasing and supporting iHog's development.")
      }
      .listRowBackground(Color.clear)
      .listRowSeparator(.hidden)
      Section {
        Text("You've been subscribed since \(user.proDateText) 🎉")
      }

      Section {
        Button("Manage your subscription") {
          showManageSubscriptionSheet.toggle()
        }
      }
    }
    .manageSubscriptionsSheet(isPresented: $showManageSubscriptionSheet)
    .task {
      user.determineProSince(network.isConnected)
    }
    .onChange(of: showManageSubscriptionSheet) { oldValue, newValue in
      user.determineUserLevel(network.isConnected)
      if user.userLevel == .free {
        dismiss()
      }
    }
  }
}

#Preview {
  SubscriptionManagementView()
    .environment(UserLevelManager(userLevel: .pro))
    .environment(NetworkManager())
}
