//
//  RegRegPlayback.swift
//  iHog
//
//  Created by Jay Wilson on 9/30/20.
//

import SwiftUI

struct RegRegPlayback: View {
  @EnvironmentObject var osc: OSCHelper
  var body: some View {
    HStack {
      VStack {
        HStack {
          FPButton(buttonText: "Back Page", buttonFunction: .backpage)
          Spacer()
          FPButton(buttonText: "Next Page", buttonFunction: .nextpage)
        }
        .frame(width: 400)
        Spacer()
        ScrollView(.horizontal) {
          LazyHStack {
            ForEach(1..<90) { num in
              VerticalMasterView(masterNumber: num).padding(.all, BASE_PADDING)
            }
          }
        }
        .padding(.horizontal)
      }
      Spacer()
      VStack {
        FPButton(buttonText: "CH", buttonFunction: .mainchoose)
          .padding(.vertical, 1.0)
        FPButton(buttonText: "A", buttonFunction: .assert)
          .padding(.bottom, 1.0)
        FPButton(buttonText: "R", buttonFunction: .release)
          .padding(.bottom, 1.0)
          .contextMenu {
            Button(
              action: {
                print("Release All")
                osc.sendReleaseAllMessage()
              },
              label: {
                Text("Release All")
              }
            )
          }
        FPButton(buttonText: ">>", buttonFunction: .skipfwd)
          .padding(.bottom, 1.0)
        FPButton(buttonText: "<<", buttonFunction: .skipback)
          .padding(.bottom, 1.0)
        FPButton(buttonText: "Back", buttonFunction: .mainback)
          .padding(.bottom, 1.0)
        FPButton(buttonText: "Pause", buttonFunction: .mainhalt)
          .padding(.bottom, 1.0)
        FPButton(buttonText: "Play", buttonFunction: .maingo)
          .padding(.bottom, 1.0)
      }
      .padding()
      .background(Color.primary)
      .cornerRadius(BASE_CORNER_RADIUS)
    }
  }
}

struct RegRegPlayback_Previews: PreviewProvider {
  static var previews: some View {
    RegRegPlayback()
  }
}
