//
//  ObjectSettings.swift
//  iHog
//
//  Created by Jay Wilson on 9/18/20.
//

import SwiftUI

struct ObjectSettings: View {
  @State private var buttonColorIndex: Int = 0
  @State private var buttonSizeIndex: Int = 0
  @State private var buttonsAcross: Int = 3
  @State private var buttonsAreOutlined: Bool = false

  // Must be singular
  var objectName: String

  // Picker selections
  let sizes: [String] = ["small", "medium", "large", "extra large"]

  var body: some View {
    Section(header: Text("\(objectName)s")) {
      // MARK: Color
      VStack(alignment: .leading) {
        Text("Button color".capitalized)
        Picker("Button Color", selection: $buttonColorIndex) {
          ForEach(0..<OBJ_COLORS.count, id: \.self) {
            Text(OBJ_COLORS[$0].description.capitalized)
          }
        }
        .pickerStyle(MenuPickerStyle())
      }
      // MARK: Size
      VStack(alignment: .leading) {
        Text("Button Size".capitalized)
        Picker("Button Size", selection: $buttonSizeIndex) {
          ForEach(0..<sizes.count, id: \.self) {
            Text(self.sizes[$0].capitalized)
          }
        }
        .pickerStyle(SegmentedPickerStyle())
      }
      // MARK: Buttons Across
      Stepper("\(buttonsAcross) buttons across".capitalized) {
        incrementButtonsAcross()
      } onDecrement: {
        decrementButtonsAcross()
      }
      // MARK: Outline or filled
      Toggle(
        "Buttons are \(buttonsAreOutlined ? "outlined" : "filled")".capitalized,
        isOn: $buttonsAreOutlined
      )

      // MARK: Button to save per section settings
      Button("Save \(objectName) Settings".capitalized) {
        print("save these settings")
      }
    }
  }

  func incrementButtonsAcross() {
    if buttonsAcross > 4 {
      buttonsAcross = 5
    } else {
      buttonsAcross = buttonsAcross + 1
    }
  }

  func decrementButtonsAcross() {
    if buttonsAcross < 2 {
      buttonsAcross = 1
    } else {
      buttonsAcross = buttonsAcross - 1
    }
  }
}

struct ObjectSettings_Previews: PreviewProvider {
  static var previews: some View {
    Group {
      Form {
        ObjectSettings(objectName: "group")
      }
    }
  }
}
