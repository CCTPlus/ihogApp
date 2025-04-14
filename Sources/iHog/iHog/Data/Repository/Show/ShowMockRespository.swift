//
//  ShowMockRespository.swift
//  iHog
//
//  Created by Jay Wilson on 4/11/25.
//

import Foundation

class ShowMockRespository: ShowRepository {
  func getCountOfShows() async throws -> Int {
    return shows.count
  }

  var shows: [Show]

  init(shows: [Show]) {
    self.shows = shows
  }

  func createShow(name: String, icon: String) async throws -> Show {
    let newShow = Show(
      dateCreated: .now,
      dateLastModified: .now,
      icon: icon,
      id: UUID(),
      name: name
    )
    shows.append(newShow)
    return newShow
  }

  func getShow(by id: UUID) async throws -> Show {
    return shows.first(where: { $0.id == id })!
  }

  func getAllShows() async throws -> [Show] {
    print(shows.count)
    return shows.sorted(by: { $0.dateLastModified > $1.dateLastModified })
  }

  func deleteShow(by id: UUID) async throws {
    shows.removeAll(where: { $0.id == id })
  }

  func deleteAll() async throws {
    shows = []
  }
}

extension ShowMockRespository {
  static let previewWithShows = ShowMockRespository(
    shows: [
      Show(
        dateCreated: .now,
        dateLastModified: .now,
        icon: "theatermasks",
        id: .init(),
        name: "Broadway Nights"
      ),
      Show(
        dateCreated: Calendar.current
          .date(byAdding: .day, value: -7, to: Date()) ?? .now,
        dateLastModified: Calendar.current
          .date(byAdding: .day, value: -1, to: Date()) ?? .now,
        icon: "film",
        name: "Taylor Swift"
      ),
    ]
  )
}
