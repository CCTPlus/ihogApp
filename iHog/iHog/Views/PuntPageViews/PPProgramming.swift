//
//  PPProgramming.swift
//  iHog
//
//  Created by Jay Wilson on 2/9/21.
//

import CoreData
import SwiftUI

struct PPProgramming: View {
  @Environment(\.managedObjectContext) private var viewContext
  @Environment(\.horizontalSizeClass) var horizontalSizeClass
  @Environment(\.verticalSizeClass) var verticalSizeClass
  @AppStorage(AppStorageKey.chosenShowID.rawValue) var chosenShowID: String = ""

  @State private var numericKeypadIsShowing = false

  @State private var chosenPaletteType = 0
  let paletteTypes: [ShowObjectType] = [.intensity, .position, .color, .beam, .effect]

  @ObservedObject var show: ChosenShow

  var body: some View {
    if horizontalSizeClass == .regular {
      if verticalSizeClass == .regular {
        HStack {
          CompRegFPprogramming()
            .padding(.all)
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
        }
      } else {
        HStack {
          VStack {
            OpenPartsView()
          }
          VStack {
            SelectButtonView()
            HBCButtonView()
            ActionButtonView()
          }
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
        }
      }
    } else {
      VStack {
        ScrollView {
          HStack {
            Spacer().frame(height: 0)
          }
          HBCButtonView()
          SelectButtonView()
            .padding(.vertical)
          OpenPartsView()
        }
        .padding(.all)
        Button(action: {
          withAnimation {
            numericKeypadIsShowing.toggle()
          }
        }) {
          Text("\(numericKeypadIsShowing ? "Hide" : "Show") Numeric Keypad")
        }
        .buttonStyle(OpenButtonStyle())
        if numericKeypadIsShowing {
          NumericKeypadView()
        } else {
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
        }
      }
    }
  }
}

//struct PPProgramming_Previews: PreviewProvider {
//    static var previews: some View {
//        PPProgramming().environmentObject(OSCHelper())
//    }
//}
