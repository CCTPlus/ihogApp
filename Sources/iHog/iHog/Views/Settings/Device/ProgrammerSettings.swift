//
//  ProgrammerSettings.swift
//  iHog
//
//  Created by Jay Wilson on 3/24/21.
//

import SwiftUI

struct ProgrammerSettings: View {
  @AppStorage(AppStorageKey.encoderWheelPrecision.rawValue) var encoderWheelPrecision: Double = 2.00
  @AppStorage(AppStorageKey.isNanoModeOn.rawValue) var isNanoModeOn: Bool = false
  @AppStorage(AppStorageKey.isHapticOn.rawValue) var isHapticOn: Bool = true

  var body: some View {
    Form {
      VStack(alignment: .leading) {
        Text("Encoder Wheel Precision: \(encoderWheelPrecision)")
        HStack {
          Slider(
            value: $encoderWheelPrecision,
            in: 0.0...20.0,
            minimumValueLabel: Text("0"),
            maximumValueLabel: Text("20")
          ) {
            Text("Encoder Wheel Precision")
          }
        }
      }
      HStack {
        Toggle("Nano Mode is \(isNanoModeOn ? "on" : "off")", isOn: $isNanoModeOn)
      }
      HStack {
        Toggle("Haptic Feedback for encoders is \(isHapticOn ? "on" : "off")", isOn: $isHapticOn)
      }
    }
    .navigationTitle("Programmer Settings")
    .navigationBarTitleDisplayMode(.inline)
  }
}

struct ProgrammerSettings_Previews: PreviewProvider {
  static var previews: some View {
    ProgrammerSettings()
  }
}
