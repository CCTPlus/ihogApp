//
//  UserProfileView.swift
//  iHog
//
//  Created by Jay Wilson on 12/6/24.
//

import PostHog
import SwiftUI

/// Used to access a user's profile from the Settings view
struct UserProfileView: View {

  var body: some View {
    List {
      // MARK: Level
      Section {
        Text("You're a pro")
        Text("Sign up for pro")
      }

      // MARK: Stats
      Section {
        Text("How many shows made")
        Text("How many objects made")
      } header: {
        Text("Stats")
      }

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

        // MARK: Experimental Features
        Section {
          Text("Feature...")
        } header: {
          Text("Experimental Features")
        } footer: {
          Text("Enabling these features may cause data loss or other issues.")
        }
      } else {
        EmptyView()
      }
    }
  }
}

#Preview {
  UserProfileView()
    .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}
