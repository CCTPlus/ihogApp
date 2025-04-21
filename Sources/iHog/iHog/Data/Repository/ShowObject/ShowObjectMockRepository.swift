//
//  ShowObjectMockRepository.swift
//  iHog
//
//  Created by Jay Wilson on 4/12/25.
//

import Foundation

/// Mock implementation of ShowObjectRepository for testing and preview purposes
final class ShowObjectMockRepository: ShowObjectRepository {
  private var objects: [ShowObject]
  private var showID: UUID?

  init(objects: [ShowObject] = [], showID: UUID? = nil) {
    self.objects = objects
    self.showID = showID
  }

  func createObject(
    for showID: UUID,
    name: String? = nil,
    type: ShowObjectType,
    color: String,
    isOutlined: Bool
  ) async throws -> ShowObject {
    let lastUsedNumber = try await getCount(for: showID, of: type)
    let objNumber = Double(lastUsedNumber + 1)
    let foundName = name ?? type.rawValue.localizedCapitalized + " " + String(objNumber)

    let newObject = ShowObject(
      id: UUID(),
      objType: type,
      number: objNumber,
      name: foundName,
      objColor: color,
      isOutlined: isOutlined
    )
    objects.append(newObject)
    return newObject
  }

  func getAllObjects(for showID: UUID) async throws -> [ShowObject] {
    return objects
  }

  func getAllObjects(from showID: UUID, of objectType: ShowObjectType) async throws -> [ShowObject]
  {
    return objects.filter { $0.objType == objectType }
  }

  func getObject(by id: UUID) async throws -> ShowObject {
    guard let object = objects.first(where: { $0.id == id }) else {
      throw HogError.objectNotFound
    }
    return object
  }

  func delete(by id: UUID) async throws {
    objects.removeAll(where: { $0.id == id })
  }

  func deleteAll() async throws {
    objects = []
  }

  func update(object: ShowObject) async throws -> ShowObject {
    guard let index = objects.firstIndex(where: { $0.id == object.id }) else {
      throw HogError.objectNotFound
    }
    objects[index] = object
    return object
  }

  func getCount(for showID: UUID, of objectType: ShowObjectType) async throws -> Int {
    return objects.filter { $0.objType == objectType }.count
  }
}

extension ShowObjectMockRepository {
  static let preview = ShowObjectMockRepository(objects: testShowObjects)
}
