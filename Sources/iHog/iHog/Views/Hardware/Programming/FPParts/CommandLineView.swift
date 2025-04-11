//
//  CommandLineView.swift
//  iHog
//
//  Created by Jay Wilson on 9/25/20.
//

import SwiftUI

struct CommandLineView: View {
  var commandLineText: String
  var body: some View {
    Text(commandLineText)
      .padding(BASE_PADDING)
      .background(Color.purple)
      .cornerRadius(BASE_CORNER_RADIUS)
      .foregroundColor(.black)
  }
}

struct CommandLineView_Previews: PreviewProvider {
  static var previews: some View {
    CommandLineView(commandLineText: "SolaSpot 1000 1 > 10 @ 100%")
  }
}
