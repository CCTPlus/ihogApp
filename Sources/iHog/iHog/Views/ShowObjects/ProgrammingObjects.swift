//
//  ProgrammingObjects.swift
//  iHog
//
//  Created by Jay Wilson on 9/18/20.
//

import CoreData
import SwiftUI

struct ProgrammingObjects: View {
  // MARK: Default values
  @AppStorage(AppStorageKey.chosenShowID.rawValue) var chosenShowID: String = ""

  // MARK: Palette defaults
  @AppStorage(AppStorageKey.buttonColorPalette.rawValue) var buttonColorPalette = 2
  @AppStorage(AppStorageKey.buttonSizePalette.rawValue) var buttonSizePalette = 0
  @AppStorage(AppStorageKey.buttonsAcrossPalette.rawValue) var buttonsAcrossPallete = 3
  @AppStorage(AppStorageKey.isButtonFilledPalette.rawValue) var isButtonFilledPalette = false

  // MARK: Group defaults
  @AppStorage(AppStorageKey.buttonColorGroup.rawValue) var buttonColorGroup = 0
  @AppStorage(AppStorageKey.buttonSizeGroup.rawValue) var buttonSizeGroup = 0
  @AppStorage(AppStorageKey.buttonsAcrossGroup.rawValue) var buttonsAcrossGroup = 3
  @AppStorage(AppStorageKey.isButtonFilledGroup.rawValue) var isButtonFilledGroup = false

  // MARK: Environment variables
  @Environment(\.horizontalSizeClass) var horizontalSizeClass
  @Environment(\.verticalSizeClass) var verticalSizeClass
  @EnvironmentObject var osc: OSCHelper

  // MARK: State
  @State private var chosenPaletteType: Int = 0
  @State private var groupObjects: [ShowObject] = []
  @State private var paletteObjects: [ShowObject] = []

  @ObservedObject var show: ChosenShow

  // MARK: Local constants
  let paletteTypes: [ShowObjectType] = [.intensity, .position, .color, .beam, .effect]
  let sizes: [String] = ["small", "medium", "large", "extra large"]

  fileprivate func returnStackView() -> some View {
    return Group {
      HStack {
        ObjectGrid(
          size: sizes[buttonSizeGroup],
          buttonsAcross: getMaxButtonSize()[0],
          objects: show.groups,
          show: show
        )
        .padding()

        // MARK: Pallets
        VStack {
          Picker("palette selection", selection: $chosenPaletteType) {
            ForEach(0..<paletteTypes.count, id: \.self) {
              Text(paletteTypes[$0].rawValue.capitalized)
            }
          }
          .pickerStyle(SegmentedPickerStyle())

          ObjectGrid(
            size: sizes[buttonSizePalette],
            buttonsAcross: getMaxButtonSize()[1],
            objects: show.palettes.filter({ obj in
              return obj.objType == paletteTypes[chosenPaletteType]
            }),
            show: show
          )
        }

      }
    }
  }

  fileprivate func returnSideBySideView() -> some View {
    return Group {
      // MARK: Groups
      ObjectGrid(
        size: sizes[buttonSizeGroup],
        buttonsAcross: getMaxButtonSize()[0],
        objects: show.groups,
        show: show
      )
      .padding()

      // MARK: Pallets
      Picker("palette selection", selection: $chosenPaletteType) {
        ForEach(0..<paletteTypes.count, id: \.self) {
          Text(paletteTypes[$0].rawValue.capitalized)
        }
      }
      .pickerStyle(SegmentedPickerStyle())

      ObjectGrid(
        size: sizes[buttonSizePalette],
        buttonsAcross: getMaxButtonSize()[1],
        objects: show.palettes.filter({ obj in
          return obj.objType == paletteTypes[chosenPaletteType]
        }),
        show: show
      )
    }
  }

  var body: some View {
    VStack {
      // MARK: Toolbar
      HStack {
        Button(action: addGroup) {
          VStack {
            Image(systemName: "plus.rectangle")
            Text("Add Group")
          }
        }
        Spacer()
        Button(action: clear) {
          VStack {
            Image(systemName: "xmark.square")
            Text("CLEAR")
          }
        }
        .foregroundColor(.red)
        Spacer()
        Button(action: addPalette) {
          VStack {
            Image(systemName: "plus.rectangle")
            Text("Add \(paletteTypes[chosenPaletteType].rawValue.localizedCapitalized)")
          }
        }
      }

      if horizontalSizeClass == .compact {
        if verticalSizeClass == .compact {
          returnStackView()
        } else {
          returnSideBySideView()
        }
      } else {
        returnStackView()
      }
    }
    .padding()
  }

  // MARK: Add Group
  func addGroup() {
    Task {
      let color = OBJ_COLORS[buttonColorGroup].description
      let isOutlined = !isButtonFilledGroup
      do {
        try await show
          .createObject(color: color, type: .group, isOutlined: isOutlined)
      } catch {
        Analytics.shared.logError(with: error, for: .coreData, level: .critical)
      }
    }
  }

  // MARK: Add Palette
  func addPalette() {
    Task {
      let color = OBJ_COLORS[buttonColorPalette].description
      let isOutlined = !isButtonFilledPalette
      do {
        try await show
          .createObject(
            color: color,
            type: paletteTypes[chosenPaletteType],
            isOutlined: isOutlined
          )
      } catch {
        Analytics.shared.logError(with: error, for: .coreData, level: .critical)
      }
    }
  }

  func clear() {
    osc.pushFrontPanelButton(button: ButtonFunctionNames.clear.rawValue)

    osc.releaseFrontPanelButton(button: ButtonFunctionNames.clear.rawValue)
  }

  /// Returns: Integer array of 2. First index is groups, Second index is palettes
  func getMaxButtonSize() -> [Int] {
    switch horizontalSizeClass {
      case .compact:
        return [getGroupButtonsAcross(), getPaletteButtonsAcross()]
      default:
        return [getGroupButtonsAcross(), getPaletteButtonsAcross()]
    }
  }

  func getPaletteButtonsAcross() -> Int {
    switch buttonSizePalette {
      // small
      case 0:
        if buttonsAcrossPallete <= SMALL_MAX_BUTTONS_ACROSS {
          return buttonsAcrossPallete
        }
        return SMALL_MAX_BUTTONS_ACROSS
      // medium
      case 1:
        if buttonsAcrossPallete <= MEDIUM_MAX_BUTTONS_ACROSS {
          return buttonsAcrossPallete
        }
        return MEDIUM_MAX_BUTTONS_ACROSS
      // large
      case 2:
        return LARGE_MAX_BUTTONS_ACROSS
      // extra large
      default:
        return XL_MAX_BUTTONS_ACROSS
    }
  }

  func getGroupButtonsAcross() -> Int {
    switch buttonSizeGroup {
      // small
      case 0:
        if buttonsAcrossGroup <= SMALL_MAX_BUTTONS_ACROSS {
          return buttonsAcrossGroup
        }
        return SMALL_MAX_BUTTONS_ACROSS
      // medium
      case 1:
        if buttonsAcrossGroup <= MEDIUM_MAX_BUTTONS_ACROSS {
          return buttonsAcrossGroup
        }
        return MEDIUM_MAX_BUTTONS_ACROSS
      // large
      case 2:
        return LARGE_MAX_BUTTONS_ACROSS
      // extra large
      default:
        return XL_MAX_BUTTONS_ACROSS
    }
  }
}

//struct ProgrammingObjects_Previews: PreviewProvider {
//    static var previews: some View {
//        ProgrammingObjects()
//    }
//}
