//
//  HogErrors.swift
//  iHog
//
//  Created by Jay Wilson on 1/19/22.
//

import Foundation
import TelemetryDeck

enum OSCErrors: String, Error, IdentifiableError {
  case failedToCreatMessage
  case udpFailedToSend
  case tcpFailedToSend
  case udpClientNotConnect
  case tcpClientNotConnect
  case udpServerNotSet
  case udpServerNotConnect
  case tcpServerNotConnect

  var id: String {
    switch self {
      default:
        String(describing: self)
          .replacingOccurrences(of: "([A-Z])", with: "-$1", options: .regularExpression)
          .lowercased()
    }
  }
}

enum HogOSCError: Error, IdentifiableError {
  case noAppGroupURL
  case notAbleToLoadStore

  var id: String {
    switch self {
      default:
        String(describing: self)
          .replacingOccurrences(of: "([A-Z])", with: "-$1", options: .regularExpression)
          .lowercased()
    }
  }

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
      default:
        String(describing: self)
          .replacingOccurrences(of: "([A-Z])", with: "-$1", options: .regularExpression)
          .lowercased()
    }
  }

  case showNotFound
  case objectTypeNotFound
  case objectTypeNoteFoundDeleting
  case objectTypeNoteFoundCreating
  case objectNotFound
}
