//
//  ShowFixture.swift
//  iHog
//
//  Created by Jay on 1/21/24.
//

import CoreData
import Foundation

struct ShowFixture {
  static func makeShow(context: NSManagedObjectContext) -> ShowEntity {
    let cal = Calendar(identifier: .gregorian)
    let components = DateComponents(
      calendar: cal,
      timeZone: .gmt,
      year: 2023,
      month: 12,
      day: 08
    )
    let date = cal.date(from: components)!

    let show = ShowEntity(context: context)
    show.dateCreated = date
    show.dateModified = date
    show.icon = "folder"
    show.givenID = FixtureConstants.uuid1
    show.name = "TS: Era's"
    show.note = "This is a note"

    return show
  }
}
