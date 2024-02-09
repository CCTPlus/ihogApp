//
//  ShowEntity+Mock.swift
//  iHog
//
//  Created by Jay on 2/9/24.
//

import Foundation

extension ShowEntity: Mockable {
  typealias MockType = ShowEntity

  /// Mock of show with objects
  static var mock: ShowEntity {
    let show = ShowFixture.makeShow(context: PersistenceController.preview.container.viewContext)
    for mockObject in ShowObjectEntity.mockList {
      show.addToObjects(mockObject)
    }
    return show
  }
}
