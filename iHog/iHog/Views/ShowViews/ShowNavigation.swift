//
//  ShowNavigation.swift
//  iHog
//
//  Created by Jay Wilson on 10/15/20.
//

import AppRouter
import SwiftUI

/// TabView for the selected show
@available(iOS 17.0, *)
struct ShowNavigation: View {
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
    TabView(selection: $selectedView) {
      ProgrammingObjects(show: chosenShow)
        .tabItem {
          Text("Program")
          Image(systemName: "paintpalette")
        }
        .tag(Views.programmingObjects)
      PlaybackObjects(show: chosenShow)
        .tabItem {
          Text("Playback")
          Image(systemName: "play.rectangle")
        }
        .tag(Views.playbackObjects)
      if user.isPro {
        PPPlayback(show: chosenShow)
          .tabItem {
            Text("Punt 1")
            Image(symbol: ._sliderhorizontalbelowsquareandsquarefilled)
          }
          .tag(Views.puntPagePlayback)
        PPProgramPlayback(show: chosenShow)
          .tabItem {
            Text("Punt 2")
            Image(systemName: "esim")
          }
          .tag(Views.puntPageProgPlay)
        PPProgramming(show: chosenShow)
          .tabItem {
            Text("Punt 3")
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
    }
    .navigationBarTitle(chosenShow.showName)
    .navigationBarTitleDisplayMode(.inline)
    .toolbar {
      // Access to show notes
      ToolbarItem(placement: .topBarTrailing) {
        Button("Notes", systemImage: "pencil.and.list.clipboard") {
          showNotes.toggle()
        }
      }
    }
    .popover(isPresented: $showNotes) {
      Text("Show Notes")
    }
  }
}

//struct ShowNavigation_Previews: PreviewProvider {
//    static var previews: some View {
//        ShowNavigation(selectedShow: testShows[2])
//    }
//}
