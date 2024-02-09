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

  static func getObjects(for showID: UUID, of objType: ObjectType) -> NSFetchRequest<
    ShowObjectEntity
  > {
    let showIDPredicate = NSPredicate(
      format: "%K == %@",
      #keyPath(ShowObjectEntity.showID),
      showID.uuidString as CVarArg
    )
    let objectTypePredicate = NSPredicate(
      format: "%K == %@",
      #keyPath(ShowObjectEntity.objType),
      objType.rawValue as CVarArg
    )

    let request = ShowObjectEntity.fetchRequest()
    request.sortDescriptors = [
      NSSortDescriptor(keyPath: \ShowObjectEntity.number, ascending: true)
    ]
    request.predicate = NSCompoundPredicate(
      type: .and,
      subpredicates: [showIDPredicate, objectTypePredicate]
    )
    return request
  }
}
