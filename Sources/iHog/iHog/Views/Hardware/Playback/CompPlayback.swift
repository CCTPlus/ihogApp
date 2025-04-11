//
//  CompPlayback.swift
//  iHog
//
//  Created by Jay Wilson on 10/1/20.
//

import SwiftUI

struct CompPlayback: View {
  @EnvironmentObject var osc: OSCHelper

  var body: some View {
    VStack {
      HStack {
        FPButton(buttonText: "Back Page", buttonFunction: .backpage)
        Spacer()
        FPButton(
          buttonText: "Next Page",
          buttonFunction: .nextpage
        )
      }
      .padding(.horizontal)
      .padding(.bottom)
      ScrollView(.vertical) {
        LazyVStack {
          ForEach(1..<90) { num in
            HorizontalMasterView(masterNumber: num).padding(.all, BASE_PADDING)
          }
        }
      }
      VertMainPlaybacks()
    }
  }
}

struct CompPlayback_Previews: PreviewProvider {
  static var previews: some View {
    CompPlayback()
      .environmentObject(OSCHelper(ip: "192.168.0.101", inputPort: 9009, outputPort: 9009))
  }
}

struct VertMainPlaybacks: View {
  @EnvironmentObject var osc: OSCHelper
  var body: some View {
    VStack {
      HStack {
        FPButton(buttonText: "CH", buttonFunction: .mainchoose)
        Spacer()
        FPButton(buttonText: "A", buttonFunction: .assert)
        Spacer()
        FPButton(buttonText: "R", buttonFunction: .release)
          .contextMenu {
            Button(
              action: {
                osc.sendReleaseAllMessage()
              },
              label: {
                Text("Release All")
              }
            )
          }
      }
      HStack {
        FPButton(buttonText: "<<", buttonFunction: .skipback)
        Spacer()
        //                FPButton(buttonText: "Pig", buttonFunction: .pig)
        Spacer()
        FPButton(buttonText: ">>", buttonFunction: .skipfwd)
      }
      HStack {
        FPButton(buttonText: "Back", buttonFunction: .mainback)
        Spacer()
        FPButton(buttonText: "Pause", buttonFunction: .mainhalt)
        Spacer()
        FPButton(buttonText: "Play", buttonFunction: .maingo)
      }
    }
    .padding(.horizontal)
    .padding(.bottom)
  }
}
