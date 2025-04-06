//
// -----------------------------------------------------------
// Project: iHog
// Created on 4/5/25 by @HeyJayWilson
// -----------------------------------------------------------
// Find HeyJayWilson on the web:
// 🕸️ Website             https://heyjaywilson.com
// 💻 Follow on GitHub:   https://github.com/heyjaywilson
// 🧵 Follow on Threads:  https://threads.net/@heyjaywilson
// 💭 Follow on Mastodon: https://iosdev.space/@heyjaywilson
// ☕ Buy me a ko-fi:     https://ko-fi.com/heyjaywilson
// -----------------------------------------------------------
// Copyright© 2025 CCT Plus LLC. All rights reserved.
//

import CoreData
import Foundation
import HogUtilities

@MainActor
public final class ShowObjectMockRepository: ShowObjectRepository {
  private var showObjects: [ShowObject]

  private let show = Show.mockShow

  public init(preloadedObjects: [ShowObject] = []) {
    showObjects = preloadedObjects
  }

  public func createShowObject(showObject: ShowObject) async throws -> ShowObject {
    let newShowObject = showObject
    showObjects.append(newShowObject)
    return newShowObject
  }

  public func getShowObjects(for showID: UUID) async throws -> [ShowObject] {
    return showObjects.filter { $0.showID == showID }
  }

  public func getShowObjects(for showID: UUID, of objType: ObjectType) async throws -> [ShowObject]
  {
    return showObjects.filter { $0.showID == showID }.filter { $0.type == objType }
  }

  public func deleteShowObject(_ showObject: ShowObject) async throws {
    //TODO: IMPLEMENT deleteShowObject
    fatalError("Implement")
  }
}
