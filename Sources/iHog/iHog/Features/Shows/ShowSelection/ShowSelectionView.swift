//
//  ShowSelectionView.swift
//  iHog
//
//  Created by Jay Wilson on 12/10/24.
//

import AppRouter
import SwiftData
import SwiftUI

struct ShowSelectionView: View {
  @Environment(\.managedObjectContext) var viewContext
  @Environment(\.modelContext) var modelContext

  @Environment(AppRouter.self) var router: AppRouter

  @AppStorage(FeatureFlagKey.swiftdata.rawValue) var swiftDataEnabled = FeatureFlagKey.swiftdata
    .isAvailable

  // Gets shows
  @FetchRequest(
    sortDescriptors: [NSSortDescriptor(keyPath: \CDShowEntity.dateLastModified, ascending: true)],
    animation: .default
  )
  private var cdShows: FetchedResults<CDShowEntity>

  @Query(sort: \ShowEntity.dateLastModified) var shows: [ShowEntity]

  var body: some View {
    Group {
      if swiftDataEnabled {
        ForEach(shows) { show in
          showRow(show)
            .contextMenu {
              Button("Delete", systemImage: "trash") {
                modelContext.delete(show)
              }
            }
        }
      } else {
        ForEach(cdShows, id: \.objectID) { show in
          Button {
            guard let showID = show.id else {
              HogLogger.log(category: .show).error("No show ID")
              return
            }
            router.changeShow(to: showID)
          } label: {
            HStack {
              ZStack {
                Color.gray
                  .frame(width: 30, height: 30)
                  .cornerRadius(5)
                Image(systemName: show.icon ?? SFSymbol._folder.name)
                  .foregroundColor(.white)
              }
              Text(show.name ?? "Name not found")
            }
          }
          .contextMenu {
            Button("Delete", systemImage: "trash") {
              viewContext.delete(show)
            }
          }
        }
      }
    }
  }
}

#Preview {
  ShowSelectionView()
    .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    .environment(\.modelContext, SwiftDataManager.previewContainer.mainContext)
    .environment(AppRouter())
}

extension ShowSelectionView {
  private func showRow(_ show: ShowEntity) -> some View {
    Button {
      guard let showID = show.id else {
        HogLogger.log(category: .show).error("No show ID")
        return
      }
      router.changeShow(to: showID)
    } label: {
      HStack {
        ZStack {
          Color.gray
            .frame(width: 30, height: 30)
            .cornerRadius(5)
          Image(systemName: show.icon ?? SFSymbol._folder.name)
            .foregroundColor(.white)
        }
        Text(show.name)
      }
    }
  }
}
