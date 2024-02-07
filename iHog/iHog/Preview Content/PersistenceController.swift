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
    for _ in 0..<10 {
      let newItem = Item(context: viewContext)
      newItem.timestamp = Date()
    }
    do {
      try viewContext.save()
    } catch {
      // Replace this implementation with code to handle the error appropriately.
      // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
      let nsError = error as NSError
      fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
    }
    result.addMockData(context: viewContext)
    return result
  }()
}
