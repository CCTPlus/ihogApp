//
//  LaunchScreenView.swift
//  iHog
//
//  Created by Jay on 1/20/24.
//

import SwiftUI

struct LaunchScreenView: View {
  @Environment(\.managedObjectContext) var moc

  @State private var sheetShown: LSSheet? = nil
  @State private var router = Router()

  var body: some View {
    NavigationStack(path: $router.path) {
      List {
        Section {
          AllShowsView()
            .environment(router)
            .appRouterDestination()
        } header: {
          HStack {
            Text("LaunchScreenView.header.shows")
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
          Text("LaunchScreenView.header.about")
        }
        InfoRow()
      }
      .navigationTitle(Text("AppTitle"))
      .sheet(item: $sheetShown) { sheet in
        switch sheet {
          case .newShow:
            ShowCreationView()
              .environment(\.managedObjectContext, moc)
              .environment(router)
        }
      }
    }
  }
}

extension LaunchScreenView {
  enum LSSheet: Identifiable {
    var id: Int {
      self.hashValue
    }
    case newShow
  }
}

#Preview {
  LaunchScreenView()
    .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}
