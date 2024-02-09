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
    name ?? viewNumber
  }

  var viewObjectType: String {
    ObjectType(rawValue: objType ?? "group")?.rawValue.first?.uppercased() ?? "🤷‍♂️"
  }
}
