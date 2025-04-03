//
//  UtilityKeySheet.swift
//  iHog
//
//  Created by Jay Wilson on 9/28/20.
//

import SwiftUI

struct UtilityKeySheet: View {
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
      UtilityButtonView().environmentObject(osc)
    }
  }
}

struct UtilityKeySheet_Previews: PreviewProvider {
  static var previews: some View {
    UtilityKeySheet()
  }
}
