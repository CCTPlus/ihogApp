//
//  Show.swift
//  iHog
//
//  Created by Jay Wilson on 4/11/25.
//

import Foundation

/// Non managed object for a ShowEntity
struct Show: Identifiable, Equatable, Codable, Sendable {
  var dateCreated: Date
  var dateLastModified: Date
  var icon: String
  var id: UUID
  var name: String

  init(
    dateCreated: Date = .now,
    dateLastModified: Date = .now,
    icon: String,
    id: UUID = .init(),
    name: String
  ) {
    self.dateCreated = dateCreated
    self.dateLastModified = dateLastModified
    self.icon = icon
    self.id = id
    self.name = name
  }

  init(from entity: ShowEntity) {
    self.dateCreated = entity.dateCreated ?? Date()
    self.dateLastModified = entity.dateLastModified ?? Date()
    self.icon = entity.icon ?? "folder"
    self.id = entity.id ?? UUID()
    self.name = entity.name
  }
}
