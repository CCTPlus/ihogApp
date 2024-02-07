//
//  PlaybackBar.swift
//  iHog
//
//  Created by Jay on 2/7/24.
//

import SwiftUI

struct PlaybackBar: View {
  var masterNumber: Int

  @State private var slider = 0.0

  var body: some View {
    VStack(spacing: 12) {
      Button {
        print("Something")
      } label: {
        Text("\(masterNumber)")
          .font(.largeTitle)
          .bold()
          .padding(.all, 4)
          .frame(maxWidth: .infinity)
      }
      .buttonStyle(.borderedProminent)
      .tint(.secondary)
      Button {
        print("Something")
      } label: {
        Image(systemName: "play.fill")
          .font(.largeTitle)
          .frame(maxWidth: .infinity)
      }
      .buttonStyle(.borderedProminent)
      .tint(.secondary)
      Button {
        print("Something")
      } label: {
        Image(systemName: "pause.fill")
          .font(.largeTitle)
          .frame(maxWidth: .infinity)
      }
      .buttonStyle(.borderedProminent)
      .tint(.secondary)
      Button {
        print("Something")
      } label: {
        Image(systemName: "play.fill")
          .font(.largeTitle)
          .rotationEffect(Angle(degrees: 180))
          .frame(maxWidth: .infinity)
      }
      .buttonStyle(.borderedProminent)
      .tint(.secondary)
      Slider(value: $slider)
        .rotationEffect(Angle(degrees: -90))
        .frame(width: 200, height: 200)
      Button {
        print("Something")
      } label: {
        Image(systemName: "lines.measurement.vertical")
          .font(.largeTitle)
          .frame(maxWidth: .infinity)
      }
      .buttonStyle(.borderedProminent)
      .tint(.secondary)
    }
    .frame(width: 100)
  }
}

#Preview {
  ScrollView {
    HStack {
      PlaybackBar(masterNumber: 100)
      PlaybackBar(masterNumber: 1)
    }
  }
}
