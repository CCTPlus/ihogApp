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
    object.givenID = FixtureConstants.uuid1
    object.isOutlined = true
    object.name = "Reputation TV"
    object.number = 13.0
    object.objType = "group"
    object.showID = FixtureConstants.uuid1.uuidString
    return object
  }

  static var mockNotOutlined: ShowObjectEntity {
    let object = ShowObjectEntity(context: PersistenceController.preview.container.viewContext)
    object.givenID = FixtureConstants.uuid1
    object.isOutlined = false
    object.name = "All"
    object.number = 1.3
    object.objType = "group"
    object.showID = FixtureConstants.uuid1.uuidString
    return object
  }

  static var mockList: [ShowObjectEntity] {
    return [.mock, .mockNotOutlined]
  }
}
