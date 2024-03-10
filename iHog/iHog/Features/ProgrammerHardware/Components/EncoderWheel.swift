//
//  EncoderWheel.swift
//  iHog
//
//  Created by Jay on 2/16/24.
//

import SwiftUI

struct EncoderWheel: View {
  @Environment(OSCManager.self) var oscManager

  @State private var height: CGFloat = 0
  @State private var yOffset: CGFloat = 0

  var wheelNumber: Int

  var dragGesture: some Gesture {
    return DragGesture()
      .onEnded({ value in
        yOffset = 0
      })
      .onChanged({ value in
        yOffset = value.location.y
        sendOSC(isPositive: value.location.y > 0)
      })
  }

  var body: some View {
    ZStack {
      RoundedRectangle(cornerRadius: 24.0)
        .fill(.secondary)
      RoundedRectangle(cornerRadius: 24.0)
        .fill(.secondary)
        .frame(width: height / 1.5, height: height / 3)
        .gesture(dragGesture)
        .offset(y: yOffset)
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .aspectRatio(1.0, contentMode: .fit)
    .heightChangePreference { measuredHeight in
      height = measuredHeight
    }
  }

  func sendOSC(isPositive: Bool) {
    // true will send a decrease encoder wheel signal to the console
    oscManager.sendEncoder(number: wheelNumber, isPositive: isPositive)
  }
}

#Preview {
  HStack(spacing: 16) {
    EncoderWheel(wheelNumber: 0)
    EncoderWheel(wheelNumber: 1)
  }
  .padding()
  .environment(OSCManager.mock)
}
