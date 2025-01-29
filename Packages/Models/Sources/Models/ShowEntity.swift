//
//  ShowEntity.swift
//  iHog
//
//  Created by Jay Wilson on 11/10/24.
//
//

import Foundation
import SwiftData

@Model public final class ShowEntity {
  public var dateCreated: Date?
  public var dateLastModified: Date?
  public var icon: String?
  public var id: UUID = UUID()
  public var name: String = "New Show"

  /// Depricated. Was never in use, but I have to keep due to cloudkit. If looking for show notes look at the property `notes`
  public var note: String?

  // MARK: Relationships
  @Relationship(deleteRule: .cascade, inverse: \ShowObjectEntity.show) public var objects:
    [ShowObjectEntity]?

  @Relationship(deleteRule: .cascade, inverse: \ShowNote.show) public var notes: [ShowNote]?

  public init(
    dateCreated: Date? = nil,
    dateLastModified: Date? = nil,
    icon: String? = nil,
    id: UUID = UUID(),
    name: String = "No show name",
    note: String? = nil,
    objects: [ShowObjectEntity]? = nil,
    notes: [ShowNote]? = nil
  ) {
    self.dateCreated = dateCreated
    self.dateLastModified = dateLastModified
    self.icon = icon
    self.id = id
    self.name = name
    self.note = note
    self.objects = objects
    self.notes = notes
  }
}
