//
//  ShowObjectEntity.swift
//  iHog
//
//  Created by Jay Wilson on 11/10/24.
//
//

import Foundation
import SwiftData

@Model class ShowObjectEntity {
  var id: UUID?
  var isOutlined: Bool?
  var name: String?
  var number: Double? = 0.0
  var objColor: String?
  var objType: String?
  var showID: String?
  var show: ShowEntity?
  init() {

  }

}
