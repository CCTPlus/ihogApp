//
//  ShowSwiftDataRepository.swift
//  iHog
//
//  Created by Jay Wilson on 4/11/25.
//

import Foundation
import SwiftData

@ModelActor
actor ShowSwiftDataRepository: ShowRepository {
  func createShow(name: String, icon: String) async throws -> Show {
    let newShowEntity = ShowEntity(icon: icon, id: UUID(), name: name)
    modelContext.insert(newShowEntity)
    try modelContext.save()
    let createdShow = Show(from: newShowEntity)
    HogLogger
      .log(category: .show)
      .debug(
        "Show created with entity ID: \(newShowEntity.id?.uuidString ?? "No ID") | Non managed ID: \(createdShow.id.uuidString)"
      )
    notifyCreatedShow(show: createdShow)
    return createdShow
  }

  func getShow(by id: UUID) async throws -> Show {
    let descriptor = FetchDescriptor<ShowEntity>(predicate: #Predicate { $0.id == id })
    guard let show = try modelContext.fetch(descriptor).first else {
      throw HogError.showNotFound
    }

    return Show(from: show)
  }

  func getAllShows() async throws -> [Show] {
    let descriptor = FetchDescriptor<ShowEntity>(
      sortBy: [SortDescriptor(\.dateLastModified, order: .reverse)]
    )

    let shows = try modelContext.fetch(descriptor)
    return shows.map { Show(from: $0) }
  }

  func deleteShow(by id: UUID) async throws {
    let descriptor = FetchDescriptor<ShowEntity>(predicate: #Predicate { $0.id == id })
    guard let show = try modelContext.fetch(descriptor).first else {
      throw HogError.showNotFound
    }
    modelContext.delete(show)
    try modelContext.save()
  }
}
