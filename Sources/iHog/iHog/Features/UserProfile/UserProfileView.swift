//
//  UserProfileView.swift
//  iHog
//
//  Created by Jay Wilson on 12/6/24.
//

import OSLog
import RevenueCat
import SwiftData
import SwiftUI

/// Used to access a user's profile from the Settings view
struct UserProfileView: View {
  @Environment(AppPaymentService.self) var appPaymentService
  @EnvironmentObject var user: UserState

  var showRepository: ShowRepository
  var showObjectRepository: ShowObjectRepository

  var body: some View {
    NavigationStack {
      List {
        // MARK: Level
        Section {
          if appPaymentService.isPro {
            Button {
              Task { @MainActor in
                do {
                  try await Purchases.shared.showManageSubscriptions()
                } catch {
                  Logger.appPaymentService.error("Cannot manage subscription \(error)")
                }
              }
            } label: {
              HStack {
                // Premium Icon
                Image(systemName: "star.square.on.square")
                  .foregroundStyle(.orange, .blue)
                  .font(.title2)

                // Text Stack
                VStack(alignment: .leading, spacing: 4) {
                  Text("Pro Subscriber")
                    .font(.headline)
                  if let proSince = appPaymentService.dateOriginallySubscribed {
                    Text("Since \(proSince.formatted(date: .abbreviated, time: .omitted))")
                      .foregroundStyle(.secondary)
                      .font(.subheadline)
                  }
                }

                Spacer()
              }
              .padding(.vertical, 4)
            }
          } else {
            Button {
              appPaymentService.triggerPaywall(for: .userRequest)
            } label: {
              VStack(alignment: .leading) {
                Text("Go PRO")
                  .font(.title)
                  .fontWeight(.black)
                Text("Unlimited shows, custom controls, and premium features await")
              }
            }
            .buttonStyle(.plain)
            .foregroundStyle(.primary)
          }
        }

        Section {
          Button("Delete all shows", action: deleteAllShows)
          Button("Delete all objects", action: deleteAllObjects)
        } header: {
          Text("Data management")
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
