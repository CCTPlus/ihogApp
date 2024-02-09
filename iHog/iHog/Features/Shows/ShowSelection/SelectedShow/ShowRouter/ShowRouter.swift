//
//  ShowRouter.swift
//  iHog
//
//  Created by Jay on 1/22/24.
//

import Foundation

@Observable
class ShowRouter {
  var selectedView: ShowRouterDestination = .programming
  var sheetShown: ShowSheet? = nil

  func changeSelectedView(to destination: ShowRouterDestination) {
    selectedView = destination
  }

  func show(sheet: ShowSheet) {
    sheetShown = sheet
  }
}
