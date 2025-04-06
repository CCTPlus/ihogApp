//
// -----------------------------------------------------------
// Project: iHog
// Created on 4/4/25 by @HeyJayWilson
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

import HogData
import SwiftUI

@Observable
@MainActor
public final class HogShowViewModel {
  var repository: ShowObjectRepository
  var showID: UUID

  public init(
    repository: ShowObjectRepository? = nil,
    persistenceController: HogPersistenceController,
    showID: UUID
  ) {
    self.showID = showID
    if let repository = repository {
      self.repository = repository
    } else {
      //TODO: IMPLEMENT ShowObjectCoreDataRepository and handle it here
      fatalError("Implement")
    }
  }
}

public struct HogShowView: View {
  @State private var viewModel: HogShowViewModel

  public init(viewModel: HogShowViewModel) {
    self.viewModel = viewModel
  }

  public var body: some View {
    VStack {
      Text("Show loaded")
    }
  }
}

#Preview {
  HogShowView(
    viewModel: HogShowViewModel(
      repository: ShowObjectMockRepository(
        preloadedObjects: ShowObject.mockShowObjects
      ),
      persistenceController: HogPersistenceController(
        inMemory: true
      ),
      showID: Show.mockShow.id
    )
  )
}
