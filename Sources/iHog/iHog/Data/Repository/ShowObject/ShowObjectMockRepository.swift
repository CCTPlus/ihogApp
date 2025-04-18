import Foundation

class ShowObjectMockRepository: ShowObjectRepository {
  var objects: [ShowObject]
  let showID: UUID

  init(objects: [ShowObject], showID: UUID) {
    self.objects = objects
    self.showID = showID
  }

  func createObject(
    for showID: UUID,
    name: String?,
    type: ShowObjectType,
    color: String,
    isOutlined: Bool
  ) async throws -> ShowObject {
    let lastUsedNumber = try await getCount(for: showID, of: type)
    let objNumber = Double(lastUsedNumber + 1)
    let foundName = name ?? type.rawValue.localizedCapitalized + " " + String(objNumber)

    let newObject = ShowObject(
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

  func getCount(for showID: UUID, of objectType: ShowObjectType) async throws -> Int {
    return objects.filter { $0.objType == objectType }.count
  }

  func delete(by id: UUID) async throws {
    objects.removeAll(where: { $0.id == id })
  }

  func deleteAll() async throws {
    objects.removeAll()
  }

  func update(object: ShowObject) async throws -> ShowObject {
    guard let index = objects.firstIndex(where: { $0.id == object.id }) else {
      throw HogError.objectNotFound
    }
    objects[index] = object
    return object
  }
}

extension ShowObjectMockRepository {
  static let preview = ShowObjectMockRepository(
    objects: [
      ShowObject(
        objType: .group,
        number: 1,
        name: "Front Wash",
        objColor: "red",
        isOutlined: true
      ),
      ShowObject(
        objType: .scene,
        number: 1,
        name: "Opening Scene",
        objColor: "blue",
        isOutlined: true
      ),
      ShowObject(
        objType: .intensity,
        number: 1,
        name: "Main Wash",
        objColor: "white",
        isOutlined: true
      ),
      ShowObject(
        objType: .color,
        number: 1,
        name: "Warm White",
        objColor: "yellow",
        isOutlined: true
      ),
    ],
    showID: ShowMockRepository.previewWithShows.shows[0].id
  )
}
