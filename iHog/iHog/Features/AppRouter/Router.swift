//
//  Router.swift
//  iHog
//
//  Created by Jay on 1/21/24.
//

import Observation

@Observable
class Router {
  var path: [RouterDestination] = []
  var sheet: SheetDestination? = nil

  func navigate(to destination: RouterDestination) {
    path.append(destination)
  }

  func show(sheet: SheetDestination) {
    self.sheet = sheet
  }
}
