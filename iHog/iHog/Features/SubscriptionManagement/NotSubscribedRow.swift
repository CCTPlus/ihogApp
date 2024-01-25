//
//  NotSubscribedRow.swift
//  iHog
//
//  Created by Jay on 1/25/24.
//

import SwiftUI

struct NotSubscribedRow: View {
  @Environment(Router.self) var router

  var body: some View {
    Button {
      router.show(sheet: .proDetail)
    } label: {
      label
    }
  }

  @ViewBuilder
  var label: some View {
    HStack {
      Text("iHog Pro")
        .bold()
      Spacer()
      Text("Not subscribed")
        .font(.footnote)
        .bold()
        .padding(.all, 8)
        .background {
          RoundedRectangle(cornerRadius: 12.0, style: .circular)
            .fill(.tertiary)
          RoundedRectangle(cornerRadius: 12.0, style: .circular)
            .fill(.thinMaterial)
        }
    }
  }
}

#Preview {
  NotSubscribedRow()
    .previewListSection()
    .environment(Router())
}
