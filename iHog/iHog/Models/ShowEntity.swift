//
//  ShowEntity.swift
//  iHog
//
//  Created by Jay on 1/20/24.
//

import Foundation

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
}
