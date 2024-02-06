//
//  ContactSection.swift
//  iHog
//
//  Created by Jay on 2/5/24.
//

import SwiftUI

struct ContactSection: View {
  var body: some View {
    Group {
      NavigationLink("Request a feature", value: RouterDestination.wishkit)
    }
  }
}

#Preview {
  ContactSection()
    .previewListSection()
}
