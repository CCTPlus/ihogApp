//
//  ListIcon.swift
//  iHog
//
//  Created by Jay Wilson on 9/13/22.
//

import SwiftUI

struct ListIcon: View {
  var color: Color
  var symbol: SFSymbol
  var body: some View {
    ZStack {
      color
        .frame(width: 30, height: 30)
        .cornerRadius(8)
      Image(symbol: symbol)
        .foregroundColor(.white)
    }
  }
}

struct ListIcon_Previews: PreviewProvider {
  static var previews: some View {
    List {
      ListIcon(color: .accentColor, symbol: ._wandandrays)
      ListIcon(color: .green, symbol: ._folder)
    }
  }
}
