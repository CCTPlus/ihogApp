//
//  ShowEntity.swift
//  iHog
//
//  Created by Jay Wilson on 11/10/24.
//
//

import Foundation
import SwiftData

@Model final class ShowEntity {
  var dateCreated: Date?
  var dateLastModified: Date?
  var icon: String?
  var id: UUID?
  var name: String = "New Show"
  var note: String?
  var objects: [ShowObjectEntity]?

  init(
    dateCreated: Date? = nil,
    dateLastModified: Date? = nil,
    icon: String? = nil,
    id: UUID = UUID(),
    name: String,
    note: String? = nil,
    objects: [ShowObjectEntity]? = nil
  ) {
    self.dateCreated = dateCreated
    self.dateLastModified = dateLastModified
    self.icon = icon
    self.id = id
    self.name = name
    self.note = note
    self.objects = objects
  }
}
