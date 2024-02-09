//
//  ShowObjectView.swift
//  iHog
//
//  Created by Jay on 2/9/24.
//

import SwiftUI

struct ShowObjectView: View {
  @Environment(OSCManager.self) var oscManager

  var showObject: ShowObjectEntity
  var size: CGSize

  var strokeWidth: CGFloat {
    showObject.isOutlined ? 4.0 : 0.0
  }

  var body: some View {
    Button {
      sendOSC()
    } label: {
      VStack(alignment: .leading) {
        HStack {
          Text("\(showObject.viewObjectType) \(showObject.viewNumber)")
            .font(.footnote)
          Spacer()
        }
        Spacer()
        Text(showObject.viewTitle)
          .lineLimit(2)
          .bold()
          .multilineTextAlignment(.leading)
      }
      .padding()
      .frame(width: size.width, height: size.height)
      .background(backgroundColor)
      .clipShape(RoundedRectangle(cornerRadius: 25.0, style: .continuous))
      .overlay {
        RoundedRectangle(cornerRadius: 25.0, style: .continuous)
          .stroke(.blue, lineWidth: strokeWidth)
      }
    }
    .buttonStyle(.plain)
  }

  @ViewBuilder
  var backgroundColor: some View {
    if showObject.isOutlined {
      Color.primary.colorInvert()
    } else {
      Color.blue
    }
  }

  // TODO: Craft the message
  func sendOSC() {
  }
}

#Preview {
  HStack {
    ShowObjectView(showObject: .mockNotOutlined, size: CGSize(width: 200, height: 200))
    ShowObjectView(showObject: .mock, size: CGSize(width: 200, height: 200))
  }
  .environment(OSCManager.mock)
}
