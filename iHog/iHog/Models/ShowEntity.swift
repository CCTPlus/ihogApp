//
//  ShowEntity.swift
//  iHog
//
//  Created by Jay on 1/20/24.
//

import Foundation
import OSLog

extension ShowEntity {
  var viewName: String {
    name ?? ""
  }

  var viewIcon: String {
    icon ?? "folder.badge.questionmark"
  }

  var viewDateModified: String {
    dateModified?.formatted(date: .numeric, time: .shortened) ?? "N/A"
  }

  var safeID: UUID {
    guard let givenID else {
      Logger.coredata.debug("\(self.viewName) no id found")
      Logger.coredata.error("🚨 No id found")
      return UUID()
    }
    return givenID
  }
}
