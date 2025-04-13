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
  @Environment(\.modelContext) var modelContext

  @Environment(AppRouter.self) var router: AppRouter

  @State private var shows: [Show] = []

  var showRespository: ShowRepository? = nil

  var body: some View {
    if shows.isEmpty == false {
      ForEach(shows) { show in
        showRow(show)
          .contextMenu {
            Button("Delete", systemImage: "trash") {
              deleteShow(by: show.id)
            }
          }
      }
    } else {
      Text("You have no shows.\nPress the \(Image(systemName: "plus.circle")) to add a new show.")
        .foregroundStyle(.secondary)
        .task {
          await getShows()
        }
    }
  }
}

#Preview {
  let container = ShowEntity.preview
  List {
    ShowSelectionView(showRespository: ShowMockRespository.previewWithShows)
      .modelContainer(container)
      .environment(AppRouter())
  }
}

extension ShowSelectionView {
  private func showRow(_ show: Show) -> some View {
    Button {
      router.changeShow(to: show.id)
    } label: {
      HStack {
        ZStack {
          RoundedRectangle(cornerRadius: 5, style: .continuous)
            .frame(width: 30, height: 30)
          Image(systemName: show.icon)
            .foregroundColor(.white)
        }
        Text(show.name)
      }
    }
  }

  private func deleteShow(by id: UUID) {
    Analytics.shared.logEvent(with: .showDeleteTapped)
    Task {
      let repo = showRespository ?? ShowSwiftDataRepository(modelContainer: modelContext.container)
      do {
        try await repo.deleteShow(by: id)
        Analytics.shared.logEvent(with: .showDeleted)
        await getShows()
      } catch {
        Analytics.shared.logError(with: error, for: .show, level: .critical)
      }
    }
  }

  private func getShows() async {
    let repo = showRespository ?? ShowSwiftDataRepository(modelContainer: modelContext.container)
    do {
      let foundShows = try await repo.getAllShows()
      await MainActor.run {
        self.shows = foundShows
      }
      HogLogger.log(category: .show).info("Found \(foundShows.count) shows")
    } catch {
      Analytics.shared.logError(with: error, for: .show, level: .critical)
    }

  }
}
