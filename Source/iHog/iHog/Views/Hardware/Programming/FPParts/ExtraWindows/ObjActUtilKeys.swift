//
//  ObjActUtilKeys.swift
//  iHog
//
//  Created by Jay Wilson on 10/18/21.
//

import SwiftUI

struct ObjActUtilKeys: View {
  /** Used to determine when the sheet is dismissed*/
  @Environment(\.verticalSizeClass) var horizontalSizeClass

  @EnvironmentObject var osc: OSCHelper

  var body: some View {
    switch horizontalSizeClass {
      case .regular:
        VStack {
          CloseButton()
          ObjectButtonView()
          Spacer()
          ActionButtonView()
          Spacer()
          UtilityButtonView()
        }
        .padding()
      default:
        VStack {
          CloseButton()
          Spacer()
          HStack {
            VStack {
              ObjectButtonView()
              Spacer()
              ActionButtonView()
            }
            Spacer()
            UtilityButtonView()
          }
        }
        .padding(.all, BASE_PADDING * 2)
    }
  }
}

struct ObjActUtilKeys_Previews: PreviewProvider {
  static var previews: some View {
    ObjActUtilKeys()
  }
}
