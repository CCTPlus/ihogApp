//
//  FunctionKeySheet.swift
//  iHog
//
//  Created by Jay Wilson on 9/28/20.
//

import SwiftUI

struct FunctionKeySheet: View {
  @EnvironmentObject var osc: OSCHelper

  var body: some View {
    VStack {
      CloseButton()
      Spacer()
      FunctionKeyView().environmentObject(osc)
    }
  }
}

struct FunctionKeySheet_Previews: PreviewProvider {
  static var previews: some View {
    FunctionKeySheet()
  }
}
