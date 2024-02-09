//
//  ShowObjectView.swift
//  iHog
//
//  Created by Jay on 2/9/24.
//

import SwiftUI

struct ShowObjectView: View {
  @Environment(OSCManager.self) var oscManager

  var backgroundColor: Color {
    showObject.isOutlined ? .clear : .blue
  }

  var strokeWidth: CGFloat {
    showObject.isOutlined ? 4.0 : 0.0
  }

  var showObject: ShowObjectEntity
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
      .frame(width: 125, height: 125)
      .background(backgroundColor)
      .clipShape(RoundedRectangle(cornerRadius: 25.0, style: .continuous))
      .overlay {
        RoundedRectangle(cornerRadius: 25.0, style: .continuous)
          .stroke(.blue, lineWidth: strokeWidth)
      }
    }
    .buttonStyle(.plain)
  }

  // TODO: Craft the message
  func sendOSC() {
  }
}

#Preview {
  HStack {
    ShowObjectView(showObject: .mockNotOutlined)
    ShowObjectView(showObject: .mock)
  }
  .environment(OSCManager.mock)
}
