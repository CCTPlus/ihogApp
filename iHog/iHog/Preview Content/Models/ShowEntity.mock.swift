//
//  ShowEntity.swift
//  iHog
//
//  Created by Jay Wilson on 12/6/24.
//

import Foundation
import SwiftData

@available(iOS 17, *)
extension ShowEntity {
  @MainActor
  static var preview: ModelContainer {
    let container = try! ModelContainer(
      for: ShowEntity.self,
      configurations: ModelConfiguration(isStoredInMemoryOnly: true)
    )
    let mockShows: [ShowEntity] = [
      ShowEntity(
        dateCreated: Date(),
        dateLastModified: Date(),
        icon: "theatermasks",
        id: UUID(),
        name: "Broadway Nights",
        note: "A spectacular musical evening"
      ),
      ShowEntity(
        dateCreated: Calendar.current.date(byAdding: .day, value: -7, to: Date()),
        dateLastModified: Calendar.current.date(byAdding: .day, value: -1, to: Date()),
        icon: "film",
        id: UUID(),
        name: "Cinema Classics",
        note: "A weekly film screening series"
      ),
      ShowEntity(
        dateCreated: Calendar.current.date(byAdding: .month, value: -2, to: Date()),
        dateLastModified: Calendar.current.date(byAdding: .month, value: -1, to: Date()),
        icon: "microphone",
        id: UUID(),
        name: "Stand-Up Saturday",
        note: "Laughter guaranteed with top comedians"
      ),
      ShowEntity(
        dateCreated: Calendar.current.date(byAdding: .year, value: -1, to: Date()),
        dateLastModified: nil,
        icon: "paintbrush",
        id: UUID(),
        name: "Art in Motion",
        note: "A blend of painting and live performance"
      ),
      ShowEntity(
        dateCreated: Calendar.current.date(byAdding: .day, value: -14, to: Date()),
        dateLastModified: Calendar.current.date(byAdding: .day, value: -7, to: Date()),
        icon: "music.note",
        id: UUID(),
        name: "Jazz Evenings",
        note: "A soulful experience of live jazz music"
      ),
    ]

    for show in mockShows {
      container.mainContext.insert(show)
    }

    return container
  }
}
