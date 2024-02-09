//
//  NSManagedObjectContext+Mockable.swift
//  iHog
//
//  Created by Jay on 2/9/24.
//

import CoreData
import Foundation

extension NSManagedObjectContext: Mockable {
  typealias MockType = NSManagedObjectContext

  static var mock: NSManagedObjectContext {
    let result = PersistenceController.preview
    let viewContext = result.container.viewContext
    let _ = ShowEntity.mock
    do {
      try viewContext.save()
    } catch {
      print(error)
    }
    return viewContext
  }
}
