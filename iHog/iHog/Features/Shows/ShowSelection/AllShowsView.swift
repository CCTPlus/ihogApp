//
//  AllShowsView.swift
//  iHog
//
//  Created by Jay on 1/20/24.
//

import OSLog
import SwiftUI

struct AllShowsView: View {
  @Environment(\.managedObjectContext) var moc

  @FetchRequest(sortDescriptors: [
    SortDescriptor(\ShowEntity.dateModified, order: .reverse)
  ])
  private var shows: FetchedResults<ShowEntity>

  var body: some View {
    ForEach(shows) { show in
      NavigationLink(value: RouterDestination.show(show.safeID)) {
        row(show)
      }
    }
    .onDelete(perform: delete)
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

  func delete(at offsets: IndexSet) {
    let index: Int = offsets.first ?? 0
    let showToDelete = shows[index]

    do {
      for showObject in showToDelete.allShowObjects {
        moc.delete(showObject)
      }
      moc.delete(showToDelete)
      try moc.save()
    } catch {
      Logger.user.error("COULDN'T DELETE SHOW")
      moc.reset()
    }
  }
}

#Preview {
  NavigationStack {
    List {
      Section {
        AllShowsView()
          .environment(\.managedObjectContext, .mock)
      }
    }
  }
}
