//
//  ShowNavigation.swift
//  iHog
//
//  Created by Jay Wilson on 10/15/20.
//

import AppRouter
import SwiftUI

/// TabView for the selected show
struct ShowNavigation: View {
  @Environment(\.modelContext) private var modelContext
  @EnvironmentObject var user: UserState
  @Environment(AppRouter.self) private var router

  @ObservedObject var chosenShow: ChosenShow

  /// The repository used to fetch and manage boards
  var boardRepository: BoardRepository? = nil
  var boardItemRepository: BoardItemRepository? = nil
  var showObjectRepository: ShowObjectRepository? = nil

  @State private var selectedView: Views = Views.programmingObjects

  enum Views: Hashable {
    case programmingObjects
    case playbackObjects
    case puntPageProgramming
    case puntPagePlayback
    case puntPageProgPlay
    case boards
  }

  var body: some View {
    TabView(selection: $selectedView) {
      ProgrammingObjects(show: chosenShow)
        .tabItem {
          Image(systemName: "paintpalette")
        }
        .tag(Views.programmingObjects)
      PlaybackObjects(show: chosenShow)
        .tabItem {
          Image(systemName: "play.rectangle")
        }
        .tag(Views.playbackObjects)
      if user.isPro {
        PPPlayback(show: chosenShow)
          .tabItem {
            Image(symbol: ._sliderhorizontalbelowsquareandsquarefilled)
          }
          .tag(Views.puntPagePlayback)
        PPProgramPlayback(show: chosenShow)
          .tabItem {
            Image(systemName: "esim")
          }
          .tag(Views.puntPageProgPlay)
        PPProgramming(show: chosenShow)
          .tabItem {
            Image(systemName: "paintbrush")
          }
          .tag(Views.puntPageProgramming)
      } else {
        CurrentPaywallView(issue: 1, analyticsSource: .puntPage)
          .tabItem {
            Image(symbol: ._sliderhorizontalbelowsquareandsquarefilled)
          }
          .tag(Views.puntPagePlayback)
      }

      BoardListView(
        showID: chosenShow.showID,
        viewModel: BoardListViewModel(
          showID: chosenShow.showID,
          repository: boardRepository
            ?? BoardSwiftDataRepository(
              modelContainer: modelContext.container
            ),
          itemRepository: boardItemRepository
            ?? BoardItemSwiftDataRepository(
              modelContainer: modelContext.container
            ),
          showObjectRepository: showObjectRepository
            ?? ShowObjectSwiftDataRepository(
              modelContainer: modelContext.container
            )
        )
      )
      .tabItem {
        Image(systemName: "rectangle.grid.2x2")
      }
      .tag(Views.boards)
    }
    .navigationBarTitle(chosenShow.showName)
    .navigationBarTitleDisplayMode(.inline)
  }
}

#Preview {
  ShowNavigation(
    chosenShow: ChosenShow(
      showID: ShowMockRepository.previewWithShows.shows[0].id,
      showObjectRepository: ShowObjectMockRepository.preview,
      showRepository: ShowMockRepository.previewWithShows
    ),
    boardRepository: BoardMockRepository.previewWithBoards
  )
  .environmentObject(UserState())
  .environment(AppRouter())
}
