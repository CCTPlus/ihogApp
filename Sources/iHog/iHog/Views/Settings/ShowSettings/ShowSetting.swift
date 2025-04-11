//
//  ShowSetting.swift
//  iHog
//
//  Created by Jay Wilson on 9/18/20.
//

import SwiftUI

struct ShowSetting: View {
  // MARK: GROUP
  @AppStorage(AppStorageKey.buttonColorGroup.rawValue) var buttonColorGroup = 0
  @AppStorage(AppStorageKey.buttonSizeGroup.rawValue) var buttonSizeGroup = 0
  @AppStorage(AppStorageKey.buttonsAcrossGroup.rawValue) var buttonsAcrossGroup = 3
  @AppStorage(AppStorageKey.isButtonFilledGroup.rawValue) var buttonFilledGroup = false
  // MARK: PALETTE
  @AppStorage(AppStorageKey.buttonColorPalette.rawValue) var buttonColorPalette = 2
  @AppStorage(AppStorageKey.buttonSizePalette.rawValue) var buttonSizePalette = 0
  @AppStorage(AppStorageKey.buttonsAcrossPalette.rawValue) var buttonsAcrossPalette = 3
  @AppStorage(AppStorageKey.isButtonFilledPalette.rawValue) var buttonFilledPalette = false
  // MARK: LIST
  @AppStorage(AppStorageKey.buttonColorList.rawValue) var buttonColorList = 0
  @AppStorage(AppStorageKey.buttonSizeList.rawValue) var buttonSizeList = 0
  @AppStorage(AppStorageKey.buttonsAcrossList.rawValue) var buttonsAcrossList = 3
  @AppStorage(AppStorageKey.isButtonFilledList.rawValue) var buttonFilledList = false
  // MARK: SCENE
  @AppStorage(AppStorageKey.buttonColorScene.rawValue) var buttonColorScene = 2
  @AppStorage(AppStorageKey.buttonSizeScene.rawValue) var buttonSizeScene = 0
  @AppStorage(AppStorageKey.buttonsAcrossScene.rawValue) var buttonsAcrossScene = 3
  @AppStorage(AppStorageKey.isButtonFilledScene.rawValue) var buttonFilledScene = false

  // Picker selections
  let sizes: [String] = ["small", "medium", "large", "extra large"]

  var body: some View {
    Form {
      // MARK: Group Settings
      Section {
        // MARK: Color
        HStack {
          Text("Button Color")
          Spacer()
          Picker("Button Color", selection: $buttonColorGroup) {
            ForEach(0..<OBJ_COLORS.count, id: \.self) {
              Text(OBJ_COLORS[$0].description.capitalized)
            }
          }
          .pickerStyle(MenuPickerStyle())
        }
        // MARK: Size
        VStack(alignment: .leading) {
          Text("Button Size".capitalized)
          Picker("Button Size", selection: $buttonSizeGroup) {
            ForEach(0..<sizes.count, id: \.self) {
              Text(self.sizes[$0].capitalized)
            }
          }
          .pickerStyle(SegmentedPickerStyle())
        }
        // MARK: Buttons Across
        Stepper(value: $buttonsAcrossGroup, in: 1...5) {
          Text("\(buttonsAcrossGroup) buttons across".capitalized)
        }
        // MARK: Outline or filled
        Toggle(
          "Buttons are \(buttonFilledGroup ? "filled" : "outlined")".capitalized,
          isOn: $buttonFilledGroup
        )
      } header: {
        Text("Groups")
      }

      // MARK: Palette Settings
      Section {
        // MARK: Color
        HStack {
          Text("Button Color")
          Spacer()
          Picker("Button Color", selection: $buttonColorPalette) {
            ForEach(0..<OBJ_COLORS.count, id: \.self) {
              Text(OBJ_COLORS[$0].description.capitalized)
            }
          }
          .pickerStyle(MenuPickerStyle())
        }
        // MARK: Size
        VStack(alignment: .leading) {
          Text("Button Size".capitalized)
          Picker("Button Size", selection: $buttonSizePalette) {
            ForEach(0..<sizes.count, id: \.self) {
              Text(self.sizes[$0].capitalized)
            }
          }
          .pickerStyle(SegmentedPickerStyle())
        }
        // MARK: Buttons Across
        Stepper(value: $buttonsAcrossPalette, in: 1...5) {
          Text("\(buttonsAcrossPalette) buttons across".capitalized)
        }
        // MARK: Outline or filled
        Toggle(
          "Buttons are \(buttonFilledPalette ? "filled" : "outlined")".capitalized,
          isOn: $buttonFilledPalette
        )
      } header: {
        Text("Palettes")
      }

      // MARK: List Settings
      Section {
        // MARK: Color
        HStack {
          Text("Button Color")
          Spacer()
          Picker("Button Color", selection: $buttonColorList) {
            ForEach(0..<OBJ_COLORS.count, id: \.self) {
              Text(OBJ_COLORS[$0].description.capitalized)
            }
          }
          .pickerStyle(MenuPickerStyle())
        }
        // MARK: Size
        VStack(alignment: .leading) {
          Text("Button Size".capitalized)
          Picker("Button Size", selection: $buttonSizeList) {
            ForEach(0..<sizes.count, id: \.self) {
              Text(self.sizes[$0].capitalized)
            }
          }
          .pickerStyle(SegmentedPickerStyle())
        }
        // MARK: Buttons Across
        Stepper(value: $buttonsAcrossList, in: 1...5) {
          Text("\(buttonsAcrossList) buttons across".capitalized)
        }
        // MARK: Outline or filled
        Toggle(
          "Buttons are \(buttonFilledList ? "filled" : "outlined")".capitalized,
          isOn: $buttonFilledList
        )
      } header: {
        Text("Lists")
      }

      // MARK: Scene Settings
      Section {
        // MARK: Color
        HStack {
          Text("Button Color")
          Spacer()
          Picker("Button Color", selection: $buttonColorScene) {
            ForEach(0..<OBJ_COLORS.count, id: \.self) {
              Text(OBJ_COLORS[$0].description.capitalized)
            }
          }
          .pickerStyle(MenuPickerStyle())
        }
        // MARK: Size
        VStack(alignment: .leading) {
          Text("Button Size".capitalized)
          Picker("Button Size", selection: $buttonSizeScene) {
            ForEach(0..<sizes.count, id: \.self) {
              if $0 < 4 {
                Text(self.sizes[$0].capitalized)
              }
            }
          }
          .pickerStyle(SegmentedPickerStyle())
        }
        // MARK: Buttons Across
        Stepper(value: $buttonsAcrossScene, in: 1...5) {
          Text("\(buttonsAcrossScene) buttons across".capitalized)
        }
        // MARK: Outline or filled
        Toggle(
          "Buttons are \(buttonFilledScene ? "filled" : "outlined")".capitalized,
          isOn: $buttonFilledScene
        )
      } header: {
        Text("Scenes")
      }
    }
    .navigationTitle("Show Settings")
    .navigationBarTitleDisplayMode(.inline)
  }
}

struct ShowSetting_Previews: PreviewProvider {
  static var previews: some View {
    ShowSetting()
  }
}
