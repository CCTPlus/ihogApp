//
//  UserCode.mock.swift
//  iHog
//
//  Created by Jay Wilson on 12/7/24.
//

import Foundation
import SwiftData

@available(iOS 17, *)
extension UserCode {
  @MainActor static var preview: ModelContainer {
    let container = try! ModelContainer(
      for: UserCode.self,
      configurations: ModelConfiguration(isStoredInMemoryOnly: true)
    )
    let mockUserCodes: [UserCode] = [
      UserCode(
        dateCreated: Date(),
        code: "ABC123"
      ),
      UserCode(
        dateCreated: Calendar.current.date(byAdding: .day, value: -1, to: Date()) ?? Date(),
        code: "XYZ789"
      ),
      UserCode(
        dateCreated: Calendar.current.date(byAdding: .day, value: -7, to: Date()) ?? Date(),
        code: "LMN456"
      ),
      UserCode(
        dateCreated: Calendar.current.date(byAdding: .month, value: -1, to: Date()) ?? Date(),
        code: "PQR321"
      ),
      UserCode(
        dateCreated: Calendar.current.date(byAdding: .year, value: -1, to: Date()) ?? Date(),
        code: "TUV654"
      ),
    ]

    for code in mockUserCodes {
      container.mainContext.insert(code)
    }
    return container
  }
}
