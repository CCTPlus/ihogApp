//
//  AllShowsView.swift
//  iHog
//
//  Created by Jay on 1/20/24.
//

import SwiftUI

struct AllShowsView: View {
  @Environment(\.managedObjectContext) var moc

  @FetchRequest(sortDescriptors: [
    SortDescriptor(\ShowEntity.dateModified, order: .reverse)
  ])
  private var shows: FetchedResults<ShowEntity>

  var body: some View {
    ForEach(shows) { show in
      NavigationLink {
        Text(show.viewName)
      } label: {
        row(show)
      }
    }
  }

  @ViewBuilder
  func row(_ show: ShowEntity) -> some View {
    HStack {
      Label {
        Text(show.viewName)
      } icon: {
        Image(systemName: show.viewIcon)
      }

      Spacer()
      Text(show.viewDateModified)
        .font(.footnote)
        .monospaced()
    }
  }
}

#Preview {
  NavigationStack {
    List {
      Section {
        AllShowsView()
          .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
      }
    }
  }
}
