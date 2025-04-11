//
//  ShowObjectEntity.swift
//  iHog
//
//  Created by Jay Wilson on 11/10/24.
//
//

import Foundation
import SwiftData

@Model final class ShowObjectEntity {
  var id: UUID?
  var isOutlined: Bool?
  var name: String?
  var number: Double? = 0.0
  var objColor: String?
  var objType: String?
  var showID: String?
  var show: ShowEntity?

  init(
    id: UUID = UUID(),
    isOutlined: Bool? = nil,
    name: String? = nil,
    number: Double? = nil,
    objColor: String? = nil,
    objType: String? = nil,
    showID: String? = nil,
    show: ShowEntity? = nil
  ) {
    self.id = id
    self.isOutlined = isOutlined
    self.name = name
    self.number = number
    self.objColor = objColor
    self.objType = objType
    self.showID = showID
    self.show = show
  }

}
