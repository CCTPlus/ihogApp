//
// -----------------------------------------------------------
// Project: iHog
// Created on 4/1/25 by @HeyJayWilson
// -----------------------------------------------------------
// Find HeyJayWilson on the web:
// 🕸️ Website             https://heyjaywilson.com
// 💻 Follow on GitHub:   https://github.com/heyjaywilson
// 🧵 Follow on Threads:  https://threads.net/@heyjaywilson
// 💭 Follow on Mastodon: https://iosdev.space/@heyjaywilson
// ☕ Buy me a ko-fi:     https://ko-fi.com/heyjaywilson
// -----------------------------------------------------------
// Copyright©t 2025 CCT Plus LLC. All rights reserved.
//

import Foundation
import HogUtilities

@MainActor
public final class ShowMockRespository: ShowRepository {
  // In-memory storage
  private var shows: [Show] = []

  public init(preloadedShows: [Show] = []) {
    self.shows = preloadedShows
  }

  public func createShow(name: String, icon: String) async throws -> Show {
    let newShow = Show(id: UUID(), icon: icon, name: name)
    shows.append(newShow)
    return newShow
  }

  public func getShow(id: UUID) async throws -> Show {
    guard let show = shows.first(where: { $0.id == id }) else {
      throw ShowError.notFound
    }
    return show
  }

  public func changeName(newName: String) async throws -> Show {
    guard let index = shows.firstIndex(where: { $0.name != newName }) else {
      throw ShowError.notFound
    }
    var updatedShow = shows[index]
    updatedShow.name = newName
    shows[index] = updatedShow
    return updatedShow
  }

  public func updateLastOpenedDate(id: UUID) async throws -> Show {
    guard let index = shows.firstIndex(where: { $0.id == id }) else {
      throw ShowError.notFound
    }
    var updatedShow = shows[index]
    updatedShow.dateLastOpened = Date()
    shows[index] = updatedShow
    return updatedShow
  }

  public func deleteShow(id: UUID) async throws {
    guard let index = shows.firstIndex(where: { $0.id == id }) else {
      throw ShowError.notFound
    }
    shows.remove(at: index)
  }

  public func fetchShows() async throws -> [Show] {
    return
      shows
      .sorted(
        by: {
          $0.dateLastOpened ?? .now > $1.dateLastOpened ?? .now
        })
  }
}
