//
//  ShowEntity.swift
//  iHog
//
//  Created by Jay Wilson on 11/10/24.
//
//

import Foundation
import SwiftData

@Model class ShowEntity {
  var dateCreated: Date?
  var dateLastModified: Date?
  var icon: String?
  var id: UUID?
  var name: String = "New Show"
  var note: String?
  var objects: [ShowObjectEntity]?

  init() {

  }

}
