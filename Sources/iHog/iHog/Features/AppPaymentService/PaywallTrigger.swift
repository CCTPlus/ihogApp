//
//  PaywallTrigger.swift
//  iHog
//
//  Created by Jay Wilson on 10/1/25.
//

enum PaywallTrigger {
  case thisIsAdamsFault
  case addShow(showCount: Int)
  case customIcons
  case userRequest
  case puntPage

  var analyticValues: String {
    switch self {
      case .thisIsAdamsFault:
        "onboarding_completed"
      case .addShow:
        "adding_show"
      case .customIcons:
        "chaning_show_icons"
      case .userRequest:
        "user_requested"
      case .puntPage:
        "punt_page"
    }
  }
}
