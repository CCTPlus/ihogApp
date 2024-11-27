//
//  AppEntryView.swift
//  Features
//
//  Created by Jay Wilson on 11/25/24.
//

import DesignSystem
import Router
import SwiftUI

public struct AppEntryView: View {
  @State private var router = Router()

  public init() {}

  public var body: some View {
    ZStack(alignment: .bottom) {
      VStack {
        HeaderView(isConnectedOSC: true)
        Spacer()
      }
      .frame(maxWidth: .infinity, maxHeight: .infinity)
      TabBarView()
        .padding()
    }
    .environment(router)
    .sheet(item: $router.presentedSheet) { sheetDestination in
      switch sheetDestination {
        case .newShow:
          Text("New show")
      }
    }
  }
}

#Preview {
  AppEntryView()
    .environment(Router())
}
