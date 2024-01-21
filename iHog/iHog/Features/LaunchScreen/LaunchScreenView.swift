//
//  LaunchScreenView.swift
//  iHog
//
//  Created by Jay on 1/20/24.
//

import SwiftUI

struct LaunchScreenView: View {
  enum LSSheet: Identifiable {
    var id: Int {
      self.hashValue
    }
    case newShow
  }

  @State private var sheetShown: LSSheet? = nil

  var body: some View {
    NavigationStack {
      List {
        Section {
          AllShowsView()
        } header: {
          HStack {
            Text("Shows")
            Spacer()
            Button {
              sheetShown = LSSheet.newShow
            } label: {
              Image(systemName: "plus.circle")
            }
          }
        }
        Section {
          AboutSection()
        } header: {
          Text("About")
        }
        InfoRow()
      }
      .navigationTitle("iHog")
      .sheet(item: $sheetShown) { sheet in
        switch sheet {
          case .newShow:
            ShowCreationView()
        }
      }
    }
  }
}

#Preview {
  LaunchScreenView()
    .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}
