//
//  ShowObjectEntity+Mock.swift
//  iHog
//
//  Created by Jay on 2/9/24.
//

import Foundation

extension ShowObjectEntity: Mockable {
  typealias MockType = ShowObjectEntity

  static var mock: ShowObjectEntity {
    let object = ShowObjectEntity(context: PersistenceController.preview.container.viewContext)
    object.givenID = UUID()
    object.isOutlined = true
    object.name = "Reputation TV"
    object.number = 13.0
    object.objType = "group"
    object.showID = FixtureConstants.uuid1.uuidString
    return object
  }

  static var mockNotOutlined: ShowObjectEntity {
    let object = ShowObjectEntity(context: PersistenceController.preview.container.viewContext)
    object.givenID = UUID()
    object.isOutlined = false
    object.name = "All"
    object.number = 1.3
    object.objType = "group"
    object.showID = FixtureConstants.uuid1.uuidString
    return object
  }

  /// SCENE
  static var mock3: ShowObjectEntity {
    let object = ShowObjectEntity(context: PersistenceController.preview.container.viewContext)
    object.givenID = UUID()
    object.isOutlined = false
    object.name = "Hello"
    object.number = 1.3
    object.objType = ObjectType.scene.rawValue
    object.showID = FixtureConstants.uuid1.uuidString
    return object
  }

  /// SCENE
  static var mock4: ShowObjectEntity {
    let object = ShowObjectEntity(context: PersistenceController.preview.container.viewContext)
    object.givenID = UUID()
    object.isOutlined = false
    object.name = "Lover"
    object.number = 13
    object.objType = ObjectType.scene.rawValue
    object.showID = FixtureConstants.uuid1.uuidString
    return object
  }

  /// SCENE
  static var mock5: ShowObjectEntity {
    let object = ShowObjectEntity(context: PersistenceController.preview.container.viewContext)
    object.givenID = UUID()
    object.isOutlined = false
    object.name = "MAIN"
    object.number = 13
    object.objType = ObjectType.list.rawValue
    object.showID = FixtureConstants.uuid1.uuidString
    return object
  }

  static var mockList: [ShowObjectEntity] {
    return [.mock, .mockNotOutlined, .mock3, .mock4, .mock5]
  }

  static func mock(with numLists: Int, type: ObjectType = .list) -> [ShowObjectEntity] {
    var objects = [ShowObjectEntity]()
    for num in 1...numLists {
      let object = ShowObjectEntity(context: PersistenceController.preview.container.viewContext)
      object.givenID = UUID()
      object.isOutlined = false
      object.name = "\(type.label) \(num)"
      object.number = Double(num)
      object.objType = type.rawValue
      object.showID = FixtureConstants.uuid1.uuidString
      objects.append(object)
    }

    return objects
  }
}
