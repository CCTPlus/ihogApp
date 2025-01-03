//
//  ShowSelectionView.swift
//  iHog
//
//  Created by Jay Wilson on 12/10/24.
//

import AppRouter
import SwiftData
import SwiftUI

@available(iOS 17, *)
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
      } else {
        ForEach(cdShows, id: \.objectID) { show in
          NavigationLink(value: Routes.shows(show)) {
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
        }
      }
    }
  }
}

@available(iOS 17, *)
#Preview {
  ShowSelectionView()
    .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    .environment(\.modelContext, SwiftDataManager.previewContainer.mainContext)
    .environment(AppRouter())
}
