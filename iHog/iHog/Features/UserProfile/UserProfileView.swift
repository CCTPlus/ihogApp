//
//  UserProfileView.swift
//  iHog
//
//  Created by Jay Wilson on 12/6/24.
//

import SwiftUI

/// Used to access a user's profile from the Settings view
struct UserProfileView: View {
  @Environment(\.managedObjectContext) var viewContext
  @EnvironmentObject var user: UserState

  var body: some View {
    NavigationStack {
      List {
        // MARK: Level
        Section {
          if user.isPro {
            HStack {
              // Premium Icon
              Image(systemName: "star.square.on.square")
                .foregroundStyle(.orange, .blue)
                .font(.title2)

              // Text Stack
              VStack(alignment: .leading, spacing: 4) {
                Text("Premium Subscriber")
                  .font(.headline)
                if let proSince = user.proSinceDate {
                  Text("Since \(proSince.formatted(date: .abbreviated, time: .omitted))")
                    .foregroundStyle(.secondary)
                    .font(.subheadline)
                }
              }

              Spacer()
            }
            .padding(.vertical, 4)
          } else {
            NavigationLink("Sign up for pro") {
              CurrentPaywallView(analyticsSource: .settings)
            }
          }
        }

        Section {
          Button("Delete all shows", action: deleteAllShows)
          Button("Delete all objects", action: deleteAllObjects)
        } header: {
          Text("Data management")
        }

        // MARK: Stats
        // TODO: Implement
        //        Section {
        //          Text("How many shows made")
        //          Text("How many objects made")
        //        } header: {
        //          Text("Stats")
        //        }

        // The user must be on iOS 17 or newer to use new features and associate analytics.
        if #available(iOS 17.0, *) {
          // MARK: Analytics
          Section {
            UserCodeView()
              .environment(\.modelContext, SwiftDataManager.modelContainer.mainContext)
          } header: {
            Text("User codes")
          } footer: {
            Text(
              "You'll only be entering codes here if you have received specific instruction to enter one or have ran the beta version of iHog."
            )
          }
          ExperimentalFeatureView()
            .environment(\.modelContext, SwiftDataManager.modelContainer.mainContext)
        } else {
          EmptyView()
        }
      }
    }
  }

  func deleteAllShows() {
    let request = CDShowEntity.fetchRequest()
    let shows = try? viewContext.fetch(request)
    shows?.forEach { viewContext.delete($0) }
    try? viewContext.save()
  }

  func deleteAllObjects() {
    let request = CDShowObjectEntity.fetchRequest()
    let objects = try? viewContext.fetch(request)
    objects?.forEach { viewContext.delete($0) }
    try? viewContext.save()
  }
}

#Preview {
  UserProfileView()
    .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    .environmentObject(UserState())
}
