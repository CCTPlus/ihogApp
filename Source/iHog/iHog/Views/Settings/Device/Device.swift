//
//  Device.swift
//  iHog
//
//  Created by Jay Wilson on 9/16/20.
//

import SwiftUI

struct Device: View {

  var body: some View {
    Form {
      OSCSettings()
      ProgrammerSettings()
      //            GameControllerSettigns()
    }
    .navigationTitle("Device Settings")
  }
}

struct Device_Previews: PreviewProvider {
  static var previews: some View {
    Device()
      .preferredColorScheme(.light)
  }
}
