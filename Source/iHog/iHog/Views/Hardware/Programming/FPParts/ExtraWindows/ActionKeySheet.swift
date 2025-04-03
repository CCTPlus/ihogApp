//
//  ActionKeySheet.swift
//  iHog
//
//  Created by Jay Wilson on 8/10/21.
//

import SwiftUI

struct ActionKeySheet: View {
  @EnvironmentObject var osc: OSCHelper
  @Environment(\.presentationMode) private var presentationMode
  var body: some View {
    VStack {
      HStack {
        Spacer()
        Button(action: {
          self.presentationMode.wrappedValue.dismiss()
        }) {
          Text("Close")
        }
        .foregroundColor(.red)
        .padding(.horizontal)
      }
      .padding(.vertical)
      Spacer()
      ActionButtonView()
        .environmentObject(osc)
        .padding()
      Spacer()
    }
  }
}

struct ActionKeySheet_Previews: PreviewProvider {
  static var previews: some View {
    ActionKeySheet()
  }
}
