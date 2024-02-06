//
//  NotSubscribedRow.swift
//  iHog
//
//  Created by Jay on 1/25/24.
//

import SwiftUI

struct SubscriptionRow: View {
  @Environment(Router.self) var router

  var isSubscribed: Bool

  var body: some View {
    Button {
      router.show(sheet: isSubscribed ? .subscriptionManagement : .paywall)
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
      Text(isSubscribed ? "Subscribed" : "Not subscribed")
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
    .tint(isSubscribed ? .green : .accentColor)
  }
}

#Preview {
  SubscriptionRow(isSubscribed: false)
    .previewListSection()
    .environment(Router())
}
