//
//  HardwareButton.swift
//  iHog
//
//  Created by Jay on 2/7/24.
//

import OSLog
import SwiftUI

struct HardwareButton: View {
  @Environment(OSCManager.self) var oscManager
  @State private var buttonHeight: CGFloat = 0

  var key: HogKey
  var masterNumber: Int? = nil
  var label: String? = nil
  var givenButtonWidth: CGFloat? = nil

  var font: Font {
    switch key {
      case .release, .h1, .h2, .h3, .h4, .h5, .h6, .h7, .h8, .h9, .h10, .h11, .h12:
        return .footnote
      case .assert, .nextPage, .intensity, .position, .color, .beam, .effect, .time, .group,
        .fixture, .back, .all, .next, .list, .scene, .cue, .macro, .live, .page, .set, .pig, .goto,
        .setup, .fan, .open, .delete, .move, .copy, .update, .merge, .record, .highlight, .blind,
        .clear:
        return .body
      default:
        return .largeTitle
    }
  }

  var tintColor: Color {
    if oscManager.blueLeds[key] == true {
      return .blue
    }

    if (oscManager.redLeds[key]?.isOn == true)
      && (oscManager.redLeds[key]?.masterNumber == masterNumber)
    {
      return .red
    }

    return .secondary
  }

  var body: some View {
    Button {
      Logger.hardware.debug("\(key.rawValue) Button pushed")
    } label: {
      if let givenButtonWidth {
        buttonLabel
          .font(font)
          .frame(width: givenButtonWidth)
          .frame(maxHeight: .infinity)
      } else {
        buttonLabel
          .font(font)
          .frame(maxWidth: .infinity)
          .frame(height: buttonHeight)
          .widthChangePreference { width in
            if masterNumber != nil {
              buttonHeight = width / 2
            } else {

              buttonHeight = width
            }
          }
      }
    }
    .buttonStyle(.borderedProminent)
    .tint(tintColor)
    .pressActions {
      oscManager.push(address: key.oscAddress(masterNumber: masterNumber))
    } onRelease: {
      oscManager.release(address: key.oscAddress(masterNumber: masterNumber))
    }

  }

  @ViewBuilder
  var buttonLabel: some View {
    if let label = label {
      Text(label)
    } else {
      key.label(masterNumber: masterNumber)
    }
  }
}

#Preview {
  HStack {
    HardwareButton(key: .pig)
    HardwareButton(key: .release)
    HardwareButton(key: .assert)
    HardwareButton(key: .nextPage)
  }
  .padding()
  .environment(OSCManager(outputPort: 9001, consoleInputPort: 9002))
}
