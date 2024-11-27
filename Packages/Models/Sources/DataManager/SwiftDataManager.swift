//
//  SwiftDataPersistence.swift
//  iHog
//
//  Created by Jay Wilson on 11/10/24.
//

import Analytics
import Foundation
import SwiftData
import Utilities

public struct SwiftDataManager {
  @MainActor public static let modelContainer = {
    let schema = Schema([
      Item.self, ShowEntity.self, ShowObjectEntity.self, TipEntity.self,
    ])

    guard
      let url = FileManager.default.containerURL(
        forSecurityApplicationGroupIdentifier: AppInfo.appGroup
      )?
      .appendingPathComponent("iHog.sqlite")
    else {
      Analytics.shared.logError(with: HogOSCError.noAppGroupURL, for: .swiftData, level: .fatal)
      fatalError(HogOSCError.noAppGroupURL.localizedDescription)
    }

    let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

    do {
      return try ModelContainer(
        for: schema,
        configurations: [modelConfiguration, ModelConfiguration(url: url)]
      )
    } catch {
      Analytics.shared.logError(with: error, for: .swiftData, level: .fatal)
      fatalError("Could not create ModelContainer: \(error)")
    }
  }()

  @MainActor public static let previewContainer = {
    let schema = Schema([
      Item.self, ShowEntity.self, ShowObjectEntity.self, TipEntity.self,
    ])

    guard
      let url = FileManager.default.containerURL(
        forSecurityApplicationGroupIdentifier: AppInfo.appGroup
      )?
      .appendingPathComponent("iHog.sqlite")
    else {
      Analytics.shared.logError(with: HogOSCError.noAppGroupURL, for: .swiftData, level: .fatal)
      fatalError(HogOSCError.noAppGroupURL.localizedDescription)
    }

    let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: true)

    do {
      return try ModelContainer(
        for: schema,
        configurations: [modelConfiguration, ModelConfiguration(url: url)]
      )
    } catch {
      Analytics.shared.logError(with: error, for: .swiftData, level: .fatal)
      fatalError("Could not create ModelContainer: \(error)")
    }
  }()
}
