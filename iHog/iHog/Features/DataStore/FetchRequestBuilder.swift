//
//  FetchRequestBuilder.swift
//  iHog
//
//  Created by Jay on 1/21/24.
//

import CoreData
import Foundation

struct FetchRequestBuilder {
  static func getShow(with id: UUID) -> NSFetchRequest<ShowEntity> {
    let request = ShowEntity.fetchRequest()
    request.sortDescriptors = []
    request.predicate = NSPredicate(format: "%K == %@", #keyPath(ShowEntity.givenID), id as CVarArg)
    request.fetchLimit = 1
    return request
  }
}
