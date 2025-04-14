//
//  ShowObjectRepository.swift
//  iHog
//
//  Created by Jay Wilson on 4/12/25.
//

import Foundation

protocol ShowObjectRepository {
  func createObject(
    for showID: UUID,
    name: String?,
    type: ShowObjectType,
    color: String,
    isOutlined: Bool
  ) async throws -> ShowObject
  func getAllObjects(for showID: UUID) async throws -> [ShowObject]
  func getAllObjects(from showID: UUID, of objectType: ShowObjectType) async throws -> [ShowObject]
  func delete(by id: UUID) async throws
  func update(object: ShowObject) async throws -> ShowObject
}
