//
//  PPProgramPlayback.swift
//  iHog
//
//  Created by Jay Wilson on 2/6/21.
//

import CoreData
import SwiftUI

struct PPProgramPlayback: View {
  @Environment(\.managedObjectContext) private var viewContext
  @Environment(\.horizontalSizeClass) var horizontalSizeClass
  @Environment(\.verticalSizeClass) var verticalSizeClass
  @AppStorage(AppStorageKey.chosenShowID.rawValue) var chosenShowID: String = ""

  //    @State private var show.groups: [ShowObject] = []
  //    @State private var show.palettes: [ShowObject] = []

  @State private var mainPlaybackIsShowing = false

  @State private var chosenPaletteType = 0

  @ObservedObject var show: ChosenShow

  let paletteTypes: [ShowObjectType] = [.intensity, .position, .color, .beam, .effect]

  var body: some View {
    if horizontalSizeClass == .regular {
      if verticalSizeClass == .regular {
        HStack {
          CompPlayback()
          VStack {
            ObjectGrid(
              size: "medium",
              buttonsAcross: 3,
              objects: show.groups,
              show: show
            )
            Picker("palette selection", selection: $chosenPaletteType) {
              ForEach(0..<paletteTypes.count, id: \.self) {
                Text(paletteTypes[$0].rawValue.capitalized)
              }
            }
            .pickerStyle(SegmentedPickerStyle())
            ObjectGrid(
              size: "medium",
              buttonsAcross: 3,
              objects: show.palettes.filter({ obj in
                return obj.objType == paletteTypes[chosenPaletteType]
              }),
              show: show
            )

          }
        }
      } else {
        HStack {
          CompactFaders(mainPlaybackIsShowing: $mainPlaybackIsShowing)
          if mainPlaybackIsShowing == false {
            VStack {
              ObjectGrid(
                size: "medium",
                buttonsAcross: 3,
                objects: show.groups,
                show: show
              )
              .transition(.move(edge: .bottom))

              VStack {
                ObjectGrid(
                  size: "medium",
                  buttonsAcross: 3,
                  objects: show.groups,
                  show: show
                )
                Picker("palette selection", selection: $chosenPaletteType) {
                  ForEach(0..<paletteTypes.count, id: \.self) {
                    Text(paletteTypes[$0].rawValue.capitalized)
                  }
                }
                .pickerStyle(SegmentedPickerStyle())
                ObjectGrid(
                  size: "medium",
                  buttonsAcross: 3,
                  objects: show.palettes.filter({ obj in
                    return obj.objType == paletteTypes[chosenPaletteType]
                  }),
                  show: show
                )

              }
            }
          } else {
            VertMainPlaybacks()
              .transition(.move(edge: .bottom))
          }
        }

      }
    } else {
      if verticalSizeClass == .regular {
        VStack {
          CompactFaders(mainPlaybackIsShowing: $mainPlaybackIsShowing)
          if mainPlaybackIsShowing == false {
            VStack {
              ObjectGrid(
                size: "small",
                buttonsAcross: 3,
                objects: show.groups,
                show: show
              )
              Picker("palette selection", selection: $chosenPaletteType) {
                ForEach(0..<paletteTypes.count, id: \.self) {
                  Text(paletteTypes[$0].rawValue.capitalized)
                }
              }
              .pickerStyle(SegmentedPickerStyle())
              ObjectGrid(
                size: "small",
                buttonsAcross: 3,
                objects: show.palettes.filter({ obj in
                  return obj.objType == paletteTypes[chosenPaletteType]
                }),
                show: show
              )

            }
          } else {
            VertMainPlaybacks()
              .transition(.move(edge: .bottom))
          }
        }
      } else {
        HStack {
          CompactFaders(mainPlaybackIsShowing: $mainPlaybackIsShowing)
          if mainPlaybackIsShowing == false {
            VStack {
              ObjectGrid(
                size: "small",
                buttonsAcross: 3,
                objects: show.groups,
                show: show
              )
              Picker("palette selection", selection: $chosenPaletteType) {
                ForEach(0..<paletteTypes.count, id: \.self) {
                  Text(paletteTypes[$0].rawValue.capitalized)
                }
              }
              .pickerStyle(SegmentedPickerStyle())
              ObjectGrid(
                size: "small",
                buttonsAcross: 3,
                objects: show.palettes.filter({ obj in
                  return obj.objType == paletteTypes[chosenPaletteType]
                }),
                show: show
              )

            }
          } else {
            VertMainPlaybacks()
              .transition(.move(edge: .bottom))
          }
        }
      }
    }
  }
}

//struct PPProgramPlayback_Previews: PreviewProvider {
//    static var previews: some View {
//        PPProgramPlayback()
//    }
//}
