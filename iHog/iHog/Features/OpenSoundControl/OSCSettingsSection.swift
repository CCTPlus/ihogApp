//
//  OSCSettingsSection.swift
//  iHog
//
//  Created by Jay on 2/5/24.
//

import SwiftUI

struct OSCSettingsSection: View {
  var body: some View {
    Group {
      NavigationLink("Configure OSC", value: RouterDestination.oscConfiguration)
      NavigationLink("OSC Log", value: RouterDestination.oscLog)
    }
  }
}

#Preview {
  NavigationStack {
    OSCSettingsSection()
      .previewListSection()
  }
}
