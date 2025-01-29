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
  @Environment(\.modelContext) var modelContext
  @EnvironmentObject var user: UserState

  @ObservedObject var chosenShow: ChosenShow

  @State var showRouter: ShowRouter

  @State private var selectedView: Views = Views.programmingObjects
  @State private var showNotes = false

  enum Views: Hashable {
    case programmingObjects
    case playbackObjects
    case puntPageProgramming
    case puntPagePlayback
    case puntPageProgPlay
    case notes
  }

  var body: some View {
    TabView(selection: $showRouter.selectedTab) {
      ProgrammingObjects(show: chosenShow)
        .tabItem {
          Text(ShowTab.programmingObjects.label)
          Image(systemName: ShowTab.programmingObjects.systemName)
        }
        .tag(ShowTab.programmingObjects)
      PlaybackObjects(show: chosenShow)
        .tabItem {
          Text(ShowTab.playbackObjects.label)
          Image(systemName: ShowTab.playbackObjects.systemName)
        }
        .tag(ShowTab.playbackObjects)
      if user.isPro {
        PPPlayback(show: chosenShow)
          .tabItem {
            Text(ShowTab.puntPagePlayback.label)
            Image(systemName: ShowTab.puntPagePlayback.systemName)
          }
          .tag(ShowTab.puntPagePlayback)
        PPProgramPlayback(show: chosenShow)
          .tabItem {
            Text(ShowTab.puntPageMix.label)
            Image(systemName: ShowTab.puntPageMix.systemName)
          }
          .tag(ShowTab.puntPageMix)
        PPProgramming(show: chosenShow)
          .tabItem {
            Text(ShowTab.puntPageProgramming.label)
            Image(systemName: ShowTab.puntPageProgramming.systemName)
          }
          .tag(ShowTab.puntPageProgramming)
      } else {
        CurrentPaywallView(issue: 1, analyticsSource: .puntPage)
          .tabItem {
            Image(symbol: ._sliderhorizontalbelowsquareandsquarefilled)
          }
          .tag(Views.puntPagePlayback)
      }
    }
    .navigationBarTitle(chosenShow.showName)
    .navigationBarTitleDisplayMode(.inline)
    .toolbar {
      // Access to show notes
      ToolbarItem(placement: .topBarTrailing) {
        Button("Notes", systemImage: "pencil.and.list.clipboard") {
          showRouter.showSheet = .showNotes
        }
      }
    }
    .popover(item: $showRouter.showSheet) { sheet in
      switch sheet {
        case .showNotes:
          if let uuid = UUID(uuidString: chosenShow.showID) {
            NavigationStack {
              ShowNotesView(showID: uuid)
            }
            .modelContainer(modelContext.container)
          }
      }
    }
    // Analytics hooks
    .onChange(of: showRouter.showSheet) {
      analyticsHookShowSheetChanges()
    }
    .onChange(of: showRouter.selectedTab) { oldValue, newValue in
      analtyicsHookTabChanges(from: oldValue, to: newValue)
    }
  }
}

// TODO: MAKE THIS WORK AGAIN
//struct ShowNavigation_Previews: PreviewProvider {
//    static var previews: some View {
//        ShowNavigation(selectedShow: testShows[2])
//    }
//}

extension ShowNavigation {
  func analyticsHookShowSheetChanges() {
    if let showSheet = showRouter.showSheet {
      let sheetName = showSheet.analyticName
      Analytics.shared.logEvent(
        with: .changeSheet,
        parameters: [.source: showRouter.selectedTab.analyticsName, .sheetName: sheetName]
      )
    } else {
      Analytics.shared.logEvent(with: .closeSheet)
    }
  }

  func analtyicsHookTabChanges(from: ShowTab, to: ShowTab) {
    Analytics.shared.logEvent(
      with: .changeTab,
      parameters: [.source: "ShowNavigation", .from: from.analyticsName, .to: to.analyticsName]
    )
  }
}
