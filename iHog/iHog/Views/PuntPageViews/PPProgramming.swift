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
  @AppStorage(Settings.chosenShowID.rawValue) var chosenShowID: String = ""

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
          .onAppear {
            getAllObjects()
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
          .onAppear {
            getAllObjects()
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
  func getAllObjects() {
    show.groups = []
    show.palettes = []
    let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "CDShowObjectEntity")
    fetchRequest.predicate = NSPredicate(format: "showID == %@", chosenShowID)

    do {
      let results = try viewContext.fetch(fetchRequest) as! [CDShowObjectEntity]
      for showObj in results {
        switch showObj.objType {
          case ShowObjectType.group.rawValue:
            let newObj = ShowObject(
              id: showObj.id!,
              objType: .group,
              number: showObj.number,
              name: showObj.name,
              objColor: showObj.objColor ?? "red",
              isOutlined: showObj.isOutlined
            )
            show.addGroup(newObj)
          case ShowObjectType.intensity.rawValue:
            let newObj = ShowObject(
              id: showObj.id!,
              objType: .intensity,
              number: showObj.number,
              name: showObj.name,
              objColor: showObj.objColor ?? "blue",
              isOutlined: showObj.isOutlined
            )
            show.addPalette(newObj)
          case ShowObjectType.position.rawValue:
            let newObj = ShowObject(
              id: showObj.id!,
              objType: .position,
              number: showObj.number,
              name: showObj.name,
              objColor: showObj.objColor ?? "blue",
              isOutlined: showObj.isOutlined
            )
            show.addPalette(newObj)
          case ShowObjectType.color.rawValue:
            let newObj = ShowObject(
              id: showObj.id!,
              objType: .color,
              number: showObj.number,
              name: showObj.name,
              objColor: showObj.objColor ?? "blue",
              isOutlined: showObj.isOutlined
            )
            show.addPalette(newObj)
          case ShowObjectType.beam.rawValue:
            let newObj = ShowObject(
              id: showObj.id!,
              objType: .beam,
              number: showObj.number,
              name: showObj.name,
              objColor: showObj.objColor ?? "blue",
              isOutlined: showObj.isOutlined
            )
            show.addPalette(newObj)
          case ShowObjectType.effect.rawValue:
            let newObj = ShowObject(
              id: showObj.id!,
              objType: .effect,
              number: showObj.number,
              name: showObj.name,
              objColor: showObj.objColor ?? "blue",
              isOutlined: showObj.isOutlined
            )
            show.addPalette(newObj)
          default:
            continue
        }
      }
      show.groups.sort(by: { $0.number < $1.number })
      show.palettes.sort(by: { $0.number < $1.number })
    } catch {
      Analytics.shared.logError(with: error, for: .coreData, level: .critical)
    }
  }
}

//struct PPProgramming_Previews: PreviewProvider {
//    static var previews: some View {
//        PPProgramming().environmentObject(OSCHelper())
//    }
//}
