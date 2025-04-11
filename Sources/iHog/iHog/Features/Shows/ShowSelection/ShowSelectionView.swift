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
      ProgressView()
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
    Task {
      let repo = showRespository ?? ShowSwiftDataRepository(modelContainer: modelContext.container)
      do {
        try await repo.deleteShow(by: id)
        await getShows()
      } catch {
        HogLogger.log(category: .show).error("Failed to delete show: \(error)")
      }
    }
  }

  private func getShows() async {
    print("Ran task")
    let repo = showRespository ?? ShowSwiftDataRepository(modelContainer: modelContext.container)
    do {
      let foundShows = try await repo.getAllShows()
      await MainActor.run {
        self.shows = foundShows
      }
      print("Found \(shows.count)")
    } catch {
      print("Failed")
      HogLogger.log(category: .show).error("Failed to fetch shows: \(error)")
    }

  }
}
