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

  func navigate(to destination: RouterDestination) {
    path.append(destination)
  }
}
