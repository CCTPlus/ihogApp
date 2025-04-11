//
//  UserCode.swift
//  iHog
//
//  Created by Jay Wilson on 12/7/24.
//

import Foundation
import SwiftData

@available(iOS 17, *)
@Model final class UserCode {
  var dateCreated: Date?
  var code: String?

  init(dateCreated: Date?, code: String?) {
    self.dateCreated = dateCreated
    self.code = code
  }

  var viewCode: String {
    code ?? ""
  }

  var viewDate: Date {
    dateCreated ?? .now
  }
}
