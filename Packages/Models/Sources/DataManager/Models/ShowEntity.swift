//
//  ShowEntity.swift
//  iHog
//
//  Created by Jay Wilson on 11/10/24.
//
//

import Foundation
import SwiftData

@Model
public final class ShowEntity {
  public var dateCreated: Date?
  public var dateLastModified: Date?
  public var icon: String?
  public var id: UUID?
  public var name: String = "New Show"
  public var note: String?

  @Relationship(inverse: \ShowObjectEntity.show)
  public var objects: [ShowObjectEntity]?

  public init(
    dateCreated: Date? = nil,
    dateLastModified: Date? = nil,
    icon: String? = nil,
    id: UUID = UUID(),
    name: String,
    note: String? = nil,
    objects: [ShowObjectEntity]? = []
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

extension ShowEntity {
  @MainActor
  public static var preview: ModelContainer {
    let container = try! ModelContainer(
      for: ShowEntity.self,
      configurations: .init(isStoredInMemoryOnly: true)
    )

    let theErasTour = ShowEntity(
      dateCreated: .now,
      dateLastModified: .now,
      icon: "lightbulb",
      name: "The Eras Tour",
      objects: [
        ShowObjectEntity(isOutlined: false, number: 1, objType: "group")
      ]
    )

    container.mainContext.insert(theErasTour)

    let hamilton = ShowEntity(
      dateCreated: .now,
      dateLastModified: .now,
      icon: "music.note",
      name: "Hamilton"
    )

    container.mainContext.insert(hamilton)

    return container
  }
}
