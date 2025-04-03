//
//  CompactFaders.swift
//  iHog
//
//  Created by Jay Wilson on 2/5/21.
//

import SwiftUI

struct CompactFaders: View {
  @EnvironmentObject var osc: OSCHelper
  @Binding var mainPlaybackIsShowing: Bool
  var body: some View {
    VStack {
      HStack {
        FPButton(
          buttonText: "Back Page",
          buttonFunction: .backpage
        )
        Spacer()
        Button("Main Buttons") {
          openMainPlaybackSheet()
        }
        .buttonStyle(OpenButtonStyle())
        Spacer()
        FPButton(
          buttonText: "Next Page",
          buttonFunction: .nextpage
        )
      }
      .padding(.horizontal)
      ScrollView(.vertical) {
        LazyVStack {
          ForEach(1..<90) { num in
            HorizontalMasterView(masterNumber: num).padding(.all, BASE_PADDING)
          }
        }
      }
    }
  }

  func openMainPlaybackSheet() {
    withAnimation {
      mainPlaybackIsShowing.toggle()
    }
  }
}

struct CompactFaders_Previews: PreviewProvider {
  static var previews: some View {
    CompactFaders(mainPlaybackIsShowing: .constant(true))
      .environmentObject(OSCHelper(ip: "192.168.0.101", inputPort: 9009, outputPort: 9009))
  }
}
