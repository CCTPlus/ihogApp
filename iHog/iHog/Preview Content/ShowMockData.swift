//
//  ShowMockData.swift
//  iHog
//
//  Created by Jay on 1/20/24.
//

import CoreData
import Foundation

extension PersistenceController {
  func addMockData(context: NSManagedObjectContext) {
    let cal = Calendar(identifier: .gregorian)
    let components = DateComponents(
      calendar: cal,
      timeZone: .gmt,
      year: 2023,
      month: 12,
      day: 08
    )
    let date = cal.date(from: components)!

    let show1 = ShowEntity(context: context)
    show1.dateCreated = date
    show1.dateModified = date
    show1.icon = "folder"
    show1.id = UUID()
    show1.name = "TS: Era's"
    show1.note = "This is a note"

    let show2 = ShowEntity(context: context)
    show2.dateCreated = date
    show2.dateModified = cal.date(byAdding: .day, value: 1, to: date)!
    show2.icon = "folder"
    show2.id = UUID()
    show2.name = "New show"
    show2.note = "This is a note"

    try? context.save()
  }
}
