//
//  PersistenceController.swift
//  iHog
//
//  Created by Jay on 2/6/24.
//

import Foundation

extension PersistenceController {
  static var preview: PersistenceController = {
    let result = PersistenceController(inMemory: true)
    let viewContext = result.container.viewContext
    result.addMockData(context: viewContext)
    return result
  }()
}
