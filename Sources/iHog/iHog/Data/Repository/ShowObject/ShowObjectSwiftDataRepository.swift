//
//  ShowObjectSwiftDataRepository.swift
//  iHog
//
//  Created by Jay Wilson on 4/12/25.
//

import Foundation
import SwiftData

@ModelActor
actor ShowObjectSwiftDataRepository: ShowObjectRepository {
  func createObject(
    for showID: UUID,
    name: String? = nil,
    type: ShowObjectType,
    color: String,
    isOutlined: Bool
  ) async throws -> ShowObject {

    let lastUsedNumber = try await getCount(for: showID, of: type)
    let objNumber = Double(lastUsedNumber + 1)
    let showEntity = try await getShowEntity(for: showID)
    let foundName = name ?? type.rawValue.localizedCapitalized + " " + String(objNumber)

    let newObjectEntity = ShowObjectEntity(
      id: UUID(),
      isOutlined: isOutlined,
      name: foundName,
      objColor: color,
      objType: type.rawValue,
      showID: showID.uuidString,
    )
    newObjectEntity.number = objNumber

    modelContext.insert(newObjectEntity)

    showEntity.objects?.append(newObjectEntity)

    try modelContext.save()

    return ShowObject(from: newObjectEntity)
  }

  func getAllObjects(for showID: UUID) async throws -> [ShowObject] {
    let showIDString = showID.uuidString
    let descriptor = FetchDescriptor<ShowObjectEntity>(
      predicate: #Predicate<ShowObjectEntity> { object in
        object.showID == showIDString
      }
    )

    let foundEntities = try modelContext.fetch(descriptor)
    return foundEntities.map({ ShowObject(from: $0) })
  }

  func getAllObjects(from showID: UUID, of objectType: ShowObjectType) async throws -> [ShowObject]
  {
    let showIDString = showID.uuidString
    let objectTypeString = objectType.rawValue
    let descriptor = FetchDescriptor<ShowObjectEntity>(
      predicate: #Predicate<ShowObjectEntity> { object in
        object.showID == showIDString && object.objType == objectTypeString
      }
    )

    let foundEntities = try modelContext.fetch(descriptor)
    return foundEntities.map({ ShowObject(from: $0) })
  }

  func getCount(for showID: UUID, of objectType: ShowObjectType) async throws -> Int {
    let showIDString = showID.uuidString
    let objectTypeString = objectType.rawValue
    let descriptor = FetchDescriptor<ShowObjectEntity>(
      predicate: #Predicate<ShowObjectEntity> { object in
        object.showID == showIDString && object.objType == objectTypeString
      }
    )

    return try modelContext.fetchCount(descriptor)
  }

  func getShowEntity(for id: UUID) async throws -> ShowEntity {
    let descriptor = FetchDescriptor<ShowEntity>(
      predicate: #Predicate<ShowEntity> { show in
        show.id == id
      }
    )
    guard let show = try modelContext.fetch(descriptor).first else {
      throw HogError.showNotFound
    }
    return show
  }

  func delete(by id: UUID) async throws {
    let descriptor = FetchDescriptor<ShowObjectEntity>(
      predicate: #Predicate<ShowObjectEntity> { $0.id == id }
    )

    guard let object = try modelContext.fetch(descriptor).first else {
      throw HogError.objectNotFound
    }
    modelContext.delete(object)
    try modelContext.save()
  }

  func update(object: ShowObject) async throws -> ShowObject {
    let objectID = object.id
    let descriptor = FetchDescriptor<ShowObjectEntity>(
      predicate: #Predicate<ShowObjectEntity> { $0.id == objectID }
    )

    guard let foundObject = try modelContext.fetch(descriptor).first else {
      throw HogError.objectNotFound
    }
    foundObject.name = object.name
    foundObject.number = object.number
    foundObject.isOutlined = object.isOutlined
    foundObject.objColor = object.objColor
    try modelContext.save()
    return ShowObject(from: foundObject)
  }

  func deleteAll() async throws {
    let descriptor = FetchDescriptor<ShowObjectEntity>()
    let objects = try modelContext.fetch(descriptor)
    objects.forEach { modelContext.delete($0) }
    try modelContext.save()
  }
}
