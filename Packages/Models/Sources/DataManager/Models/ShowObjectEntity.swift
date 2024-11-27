//
//  ShowObjectEntity.swift
//  iHog
//
//  Created by Jay Wilson on 11/10/24.
//
//

import Foundation
import SwiftData

@Model
public final class ShowObjectEntity {
  public var id: UUID?
  public var isOutlined: Bool?
  public var name: String?
  public var number: Double? = 0.0
  public var objColor: String?
  public var objType: String?
  public var showID: String?
  public var show: ShowEntity?

  public init(
    id: UUID = UUID(),
    isOutlined: Bool? = false,
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
