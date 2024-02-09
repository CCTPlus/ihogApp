//
//  ShowObjectEntity.swift
//  iHog
//
//  Created by Jay on 2/9/24.
//

import Foundation

extension ShowObjectEntity {
  var viewNumber: String {
    String(format: "%g", number)
  }

  var viewTitle: String {
    if let name,
      name.isEmpty == false
    {
      return name
    }
    return safeObjType.label + " \(viewNumber)"
  }

  var safeObjType: ObjectType {
    ObjectType(rawValue: objType!)!
  }
  var viewObjectType: String {
    ObjectType(rawValue: objType ?? "group")?.rawValue.first?.uppercased() ?? "🤷‍♂️"
  }
}
