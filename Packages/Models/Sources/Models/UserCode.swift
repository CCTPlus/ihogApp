//
//  UserCode.swift
//  iHog
//
//  Created by Jay Wilson on 12/7/24.
//

import Foundation
import SwiftData

@Model public final class UserCode {
  public var dateCreated: Date?
  public var code: String?

  public init(dateCreated: Date?, code: String?) {
    self.dateCreated = dateCreated
    self.code = code
  }

  public var viewCode: String {
    code ?? ""
  }

  public var viewDate: Date {
    dateCreated ?? .now
  }
}
