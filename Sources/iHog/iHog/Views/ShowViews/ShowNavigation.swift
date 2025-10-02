//
//  ShowNavigation.swift
//  iHog
//
//  Created by Jay Wilson on 10/15/20.
//

import RevenueCatUI
import SwiftUI

/// TabView for the selected show
struct ShowNavigation: View {
  @Environment(AppPaymentService.self) var appPaymentService: AppPaymentService
  @EnvironmentObject var user: UserState

  @ObservedObject var chosenShow: ChosenShow

  @State private var selectedView: Views = Views.programmingObjects

  enum Views: Hashable {
    case programmingObjects
    case playbackObjects
    case puntPageProgramming
    case puntPagePlayback
    case puntPageProgPlay
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
      if appPaymentService.isPro {
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
        HogPaywallView(showDismiss: false, source: .puntPage)
          .task {
            appPaymentService.lastUsedTrigger = .puntPage
          }
          .tabItem {
            Image(symbol: ._sliderhorizontalbelowsquareandsquarefilled)
          }
          .tag(Views.puntPagePlayback)
      }
    }
    .navigationBarTitle(chosenShow.showName)
    .navigationBarTitleDisplayMode(.inline)
  }
}

//struct ShowNavigation_Previews: PreviewProvider {
//    static var previews: some View {
//        ShowNavigation(selectedShow: testShows[2])
//    }
//}
