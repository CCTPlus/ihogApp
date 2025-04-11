//
//  HogErrors.swift
//  iHog
//
//  Created by Jay Wilson on 1/19/22.
//

import Foundation
import TelemetryDeck

public enum OSCErrors: String, Error {
  case FailedToCreateMessage = "Message was not created"
  case UDPFailedToSend = "UDP didn't send message"
  case TCPFailedToSend = "TCP didn't send message"
  case UDPClientNotConnect
  case TCPClientNotConnect
  case UDPServerNotSet
  case UDPServerNotConnect
  case TCPServerNotConnect
}

enum HogOSCError: Error {
  case noAppGroupURL
  case notAbleToLoadStore

  var localizedDescription: String {
    switch self {
      case .noAppGroupURL:
        "Shared file container could not be created"
      case .notAbleToLoadStore:
        "Could not load a persistent store"
    }
  }
}

enum HogError: IdentifiableError, Error {
  var id: String {
    switch self {
      case .showNotFound:
        "ShowNotFound"
    }
  }

  case showNotFound
}
