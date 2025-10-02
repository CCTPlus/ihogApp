//
//  UserProfileView.swift
//  iHog
//
//  Created by Jay Wilson on 12/6/24.
//

import SwiftData
import SwiftUI

/// Used to access a user's profile from the Settings view
struct UserProfileView: View {
  @EnvironmentObject var user: UserState

  var showRepository: ShowRepository
  var showObjectRepository: ShowObjectRepository

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
        // MARK: Analytics
        Section {
          UserCodeView()
          //              .environment(\.modelContext, SwiftDataManager.modelContainer.mainContext)
        } header: {
          Text("User codes")
        } footer: {
          Text(
            "You'll only be entering codes here if you have received specific instruction to enter one or have ran the beta version of iHog."
          )
        }
      }
    }
  }

  func deleteAllShows() {
    Task {
      do {
        try await showRepository.deleteAll()
      } catch {
        Analytics.shared
          .logError(with: error, for: .userProfile, level: .critical)
      }
    }
  }

  func deleteAllObjects() {
    Task {
      do {
        try await showObjectRepository.deleteAll()
      } catch {
        Analytics.shared
          .logError(with: error, for: .userProfile, level: .critical)
      }
    }
  }
}

//#Preview {
//  UserProfileView(
//    showRepository: ShowMockRespository.previewWithShows,
//    showObjectRepository: ShowObjectSwiftDataRepository(
//      modelContainer: SwiftDataManager.previewContainer
//    )
//  )
//    .environmentObject(UserState())
//}
