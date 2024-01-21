//
//  InfoSection.swift
//  iHog
//
//  Created by Jay on 1/21/24.
//

import SwiftUI

struct InfoRow: View {
  let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "NA"
  let build = Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "NA"

  var body: some View {
    VStack {
      Text("iHog v\(appVersion)(\(build))")
        .font(.headline)
        .padding(.bottom, 2)
      Text("developed by [Jay Wilson](https://heyjaywilson.com) 👋")
        .font(.subheadline)
        .textCase(.lowercase)
        .foregroundStyle(.secondary)
      Text("Made in 🇺🇸 with lots of coffee ☕")
        .font(.subheadline)
        .textCase(.lowercase)
        .foregroundStyle(.secondary)
    }
    .frame(maxWidth: .infinity)
    .listRowBackground(Color.clear)
  }
}

#Preview {
  InfoRow()
    .previewList()
}
