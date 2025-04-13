//
//  PPPlayback.swift
//  iHog
//
//  Created by Jay Wilson on 2/4/21.
//

import CoreData
import SwiftUI

struct PPPlayback: View {
  @Environment(\.managedObjectContext) private var viewContext
  @Environment(\.horizontalSizeClass) var horizontalSizeClass
  @Environment(\.verticalSizeClass) var verticalSizeClass
  @AppStorage(AppStorageKey.chosenShowID.rawValue) var chosenShowID: String = ""

  @State private var mainPlaybackIsShowing = false

  @ObservedObject var show: ChosenShow

  var body: some View {
    if horizontalSizeClass == .regular {
      if verticalSizeClass == .regular {
        HStack {
          CompPlayback()
          ObjectGrid(
            size: "medium",
            buttonsAcross: 3,
            objects: show.playbackObjects,
            show: show
          )
        }
        .onAppear {
          //          getAllObjects()
        }
      } else {
        HStack {
          CompactFaders(mainPlaybackIsShowing: $mainPlaybackIsShowing)
          if mainPlaybackIsShowing == false {
            ObjectGrid(
              size: "medium",
              buttonsAcross: 3,
              objects: show.playbackObjects,
              show: show
            )
            .transition(.move(edge: .bottom))
          } else {
            VertMainPlaybacks()
              .transition(.move(edge: .bottom))
          }
        }
        .onAppear {
          //          getAllObjects()
        }

      }
    } else {
      if verticalSizeClass == .regular {
        VStack {
          CompactFaders(mainPlaybackIsShowing: $mainPlaybackIsShowing)
          if mainPlaybackIsShowing == false {
            ObjectGrid(
              size: "medium",
              buttonsAcross: 3,
              objects: show.playbackObjects,
              show: show
            )
            .transition(.move(edge: .bottom))
          } else {
            VertMainPlaybacks()
              .transition(.move(edge: .bottom))
          }
        }
        .onAppear {
          //          getAllObjects
          ()
        }
      } else {
        HStack {
          CompactFaders(mainPlaybackIsShowing: $mainPlaybackIsShowing)
          if mainPlaybackIsShowing == false {
            ObjectGrid(
              size: "medium",
              buttonsAcross: 3,
              objects: show.playbackObjects,
              show: show
            )
            .transition(.move(edge: .bottom))
          } else {
            VertMainPlaybacks()
              .transition(.move(edge: .bottom))
          }
        }
      }
    }
  }
}
//struct PPPlayback_Previews: PreviewProvider {
//    static var previews: some View {
//        PPPlayback()
//    }
//}
