//
//  LaunchScreenView.swift
//  iHog
//
//  Created by Jay on 1/20/24.
//

import SwiftUI

struct LaunchScreenView: View {
  var body: some View {
    NavigationStack {
      List {
        Section {
          AllShowsView()
        } header: {
          Text("Shows")
        }
        Section {
          AboutSection()
        } header: {
          Text("About")
        }
        InfoRow()
      }
      .navigationTitle("iHog")
    }
  }
}

#Preview {
  LaunchScreenView()
    .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}
