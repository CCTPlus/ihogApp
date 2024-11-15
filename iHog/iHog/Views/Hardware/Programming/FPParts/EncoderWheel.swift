//
//  EncoderWheel.swift
//  iHog
//
//  Created by Jay Wilson on 9/24/20.
//

import CoreHaptics
import SwiftUI

struct EncoderWheel: View {
  @EnvironmentObject var osc: OSCHelper
  @Environment(\.horizontalSizeClass) var horizontalSizeClass

  @AppStorage(Settings.encoderWheelPrecision.rawValue) var encoderWheelPrecision: Double = 2.00
  @AppStorage(Settings.isHapticOn.rawValue) var isHapticOn: Bool = true

  @State private var engine: CHHapticEngine?
  @State private var yOffSet: CGFloat = 0

  var widthHeight: CGFloat {
    if horizontalSizeClass == .compact {
      return CGFloat(100.0)
    } else {
      return CGFloat(150.0)
    }
  }

  var encoderWheelNum: Int
  var paramName: String
  var paramValue: String
  var body: some View {
    ZStack {
      RoundedRectangle(cornerRadius: 20.0)
        .fill(Color.gray)
        .aspectRatio(1.0, contentMode: .fit)
      VStack {
        Text(paramName)
          .font(.headline)
        Text("\(paramValue)")
          .font(.subheadline)
      }
      .foregroundColor(.primary)
      // MARK: Small Grab thing
      RoundedRectangle(cornerRadius: 5.0)
        .fill(Color.init(.sRGB, red: 0, green: 0, blue: 0, opacity: 0.25))
        .frame(width: 30, height: 20, alignment: .center)
        .offset(y: yOffSet)
        .gesture(
          DragGesture()
            .onEnded({ value in
              yOffSet = 0
            })
            .onChanged({ value in
              sendEncoder(newValue: value.location.y)
            })
        )
    }
    .onTapGesture {
      print("DO SOMETHING")
    }
    .padding(2)
    .frame(width: 100, height: 100, alignment: .center)
    .onAppear(perform: prepareHaptics)
  }

  func sendEncoder(newValue: CGFloat) {
    isHapticOn ? complexSuccess() : print("turned off")

    if newValue < yOffSet {
      osc.sendEncoderWheelValue(encoderNum: encoderWheelNum, value: encoderWheelPrecision)
      yOffSet = newValue
    } else {
      osc.sendEncoderWheelValue(encoderNum: encoderWheelNum, value: -(encoderWheelPrecision))
      yOffSet = newValue
    }
  }

  func prepareHaptics() {
    guard CHHapticEngine.capabilitiesForHardware().supportsHaptics else { return }

    do {
      self.engine = try CHHapticEngine()
      try engine?.start()
    } catch {
      Analytics.shared.logError(with: error, for: .haptics, level: .warning)
    }
  }

  func complexSuccess() {
    // make sure that the device supports haptics
    guard CHHapticEngine.capabilitiesForHardware().supportsHaptics else { return }
    var events = [CHHapticEvent]()

    // create one intense, sharp tap
    let intensity = CHHapticEventParameter(parameterID: .hapticIntensity, value: 2)
    let sharpness = CHHapticEventParameter(parameterID: .hapticSharpness, value: 0.5)
    let event = CHHapticEvent(
      eventType: .hapticTransient,
      parameters: [intensity, sharpness],
      relativeTime: 0
    )
    events.append(event)

    // convert those events into a pattern and play it immediately
    do {
      let pattern = try CHHapticPattern(events: events, parameters: [])
      let player = try engine?.makePlayer(with: pattern)
      try player?.start(atTime: 0)
    } catch {
      Analytics.shared.logError(with: error, for: .haptics, level: .warning)
    }
  }
}

struct EncoderWheel_Previews: PreviewProvider {
  static var previews: some View {
    Group {
      HStack {
        EncoderWheel(encoderWheelNum: 1, paramName: "Pan", paramValue: "0")
        EncoderWheel(encoderWheelNum: 1, paramName: "Tilt", paramValue: "0")
        EncoderWheel(encoderWheelNum: 1, paramName: "Zoom", paramValue: "0")
        EncoderWheel(encoderWheelNum: 1, paramName: "Focus", paramValue: "0")
        EncoderWheel(encoderWheelNum: 1, paramName: "Gobo 2", paramValue: "Slots")
      }
      HStack {
        EncoderWheel(encoderWheelNum: 1, paramName: "Pan", paramValue: "0")
        EncoderWheel(encoderWheelNum: 1, paramName: "Tilt", paramValue: "0")
        EncoderWheel(encoderWheelNum: 1, paramName: "Zoom", paramValue: "0")
        EncoderWheel(encoderWheelNum: 1, paramName: "Focus", paramValue: "0")
        EncoderWheel(encoderWheelNum: 1, paramName: "Gobo 2 <>", paramValue: "0")
      }
      .preferredColorScheme(.dark)
    }
  }
}
