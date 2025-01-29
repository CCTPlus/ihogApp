//
//  ShowSelectionView.swift
//  iHog
//
//  Created by Jay Wilson on 12/10/24.
//

import AppRouter
import Models
import SwiftData
import SwiftUI

struct ShowSelectionView: View {
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
    ForEach(shows) { show in
      showRow(show)
        .contextMenu {
          Button("Delete", systemImage: "trash") {
            modelContext.delete(show)
          }
        }
    }
  }
}

#Preview {
  ShowSelectionView()
    .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    .modelContext(SwiftDataManager.previewContainer.mainContext)
    .environment(AppRouter())
}

extension ShowSelectionView {
  private func showRow(_ show: ShowEntity) -> some View {
    Button {
      router.changeShow(to: show.id)
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
