//
//  ShowManager.swift
//  iHog
//
//  Created by Jay on 1/21/24.
//

import CoreData
import Foundation

enum ShowManagerError: Error {
  case noShowName
}

struct ShowManager {
  let persistenceController: PersistenceController

  private var backgroundContext: NSManagedObjectContext {
    persistenceController.container.newBackgroundContext()
  }

  init(persistenceController: PersistenceController = PersistenceController.shared) {
    self.persistenceController = persistenceController
  }

  func createShow(name: String, id: UUID = UUID(), todayDate: Date = Date()) throws
    -> UUID
  {
    guard name.isEmpty == false else { throw ShowManagerError.noShowName }
    let backgroundContext = self.backgroundContext
    let showID = try backgroundContext.performAndWait {
      let show = ShowEntity(context: backgroundContext)
      show.givenID = id
      show.name = name
      show.dateCreated = todayDate
      show.dateModified = todayDate

      try backgroundContext.save()
      return show.safeID
    }

    return showID
  }
}
