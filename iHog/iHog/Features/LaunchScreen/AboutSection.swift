//
//  AboutSection.swift
//  iHog
//
//  Created by Jay on 1/20/24.
//

import SwiftUI

struct AboutSection: View {
  @State private var isShowingLibraries = false

  var body: some View {
    Link(
      destination: URL(string: "https://github.com/cctplus/ihogapp")!,
      label: {
        Label("Privacy", systemImage: "lock")
      }
    )
    Link(
      destination: URL(string: "https://github.com/cctplus/ihogapp")!,
      label: {
        Label("Terms", systemImage: "doc.text")
      }
    )
    Button {
      isShowingLibraries.toggle()
    } label: {
      Label("Libraries used to make iHog", systemImage: "laptopcomputer.and.ipad")
    }
    .sheet(isPresented: $isShowingLibraries) {
      Text("Do this later")
    }
  }
}

#Preview {
  AboutSection()
    .previewList()
}
