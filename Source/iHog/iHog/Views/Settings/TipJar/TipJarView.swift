//
//  TipJarView.swift
//  iHog
//
//  Created by Jay Wilson on 2/20/21.
//

import CoreData
import RevenueCat
import StoreKit
import SwiftUI

struct TipJarView: View {
  var body: some View {
    VStack(alignment: .leading) {
      Text(
        "I'm one person building iHog, and it relies on your support for development. Pay what you want when you want and no matter what you will be loved for it 💙"
      )
      .padding()
    }
    .navigationBarTitle("Tip Jar")
  }
}

struct TipJarView_Previews: PreviewProvider {
  static var previews: some View {
    TipJarView()
  }
}
