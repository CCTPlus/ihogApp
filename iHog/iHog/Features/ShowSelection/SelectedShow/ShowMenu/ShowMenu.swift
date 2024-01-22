//
//  ShowMenu.swift
//  iHog
//
//  Created by Jay on 1/22/24.
//

import SwiftUI

struct ShowMenu: View {
  @Bindable var showRouter: ShowRouter

  var body: some View {
    ForEach(ShowRouterDestination.allCases) { destination in
      Button {
        showRouter.changeSelectedView(to: destination)
      } label: {
        destination.label(isSelected: showRouter.selectedView == destination)
      }
    }
  }
}

#Preview {
  ShowMenu(showRouter: ShowRouter())
}
