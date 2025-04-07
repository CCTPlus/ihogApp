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

import HogAnalytics
import HogData
import HogEnvironment
import HogRouter
import SwiftUI

@Observable
@MainActor
public final class HogShowViewModel {
  var repository: ShowObjectRepository
  let showID: UUID

  var groupObjects: [ShowObject] = []

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
      self.repository = ShowObjectMockRepository(preloadedObjects: ShowObject.mockShowObjects)
    }
  }

  func getGroups() async throws {
    let foundGroups = try await repository.getShowObjects(for: showID, of: .group)
    // Do filtering work off the main actor
    let existingObjects = Set(groupObjects)
    let newObjects = foundGroups.filter { !existingObjects.contains($0) }

    // Only switch to main actor for the final update
    await MainActor.run {
      groupObjects.append(contentsOf: newObjects)
    }
  }
}

public struct HogShowView: View {
  @Environment(HogRouter.self) var hogRouter
  @State private var viewModel: HogShowViewModel

  public init(viewModel: HogShowViewModel) {
    self.viewModel = viewModel
  }

  public var body: some View {
    ZStack(alignment: .top) {
      Color.primary.colorInvert()
        .ignoresSafeArea()
        .task {
          do {
            try await viewModel.getGroups()
          } catch {
            print("Error: \(error)")
          }
        }
      VStack {
        toolbar
        TabView {
          ShowObjectGridView(showObjects: viewModel.groupObjects)
            .tabItem {
              Image(systemName: "paintpalette")
            }
            .tag(1)
          Text("Playback")
            .tabItem {
              Image(systemName: "play.rectangle.fill")
            }
            .tag(2)
          Text("Punt 1")
            .tabItem {
              Image(systemName: "slider.horizontal.below.square.and.square.filled")
            }
            .tag(3)
          Text("Punt 2")
            .tabItem {
              Image(systemName: "esim")
            }
            .tag(4)
          Text("Punt 3")
            .tabItem {
              Image(systemName: "paintbrush")
            }
            .tag(5)
        }
      }
    }
  }

  @ViewBuilder
  var toolbar: some View {
    ZStack {
      HStack(spacing: 16) {
        Button {
          print("Open prog hardwar")
        } label: {
          Image(systemName: "cooktop")
        }
        .buttonStyle(.borderedProminent)
        Button {
          print("Open prog hardwar")
        } label: {
          Image(systemName: "slider.vertical.3")
        }
        .buttonStyle(.borderedProminent)
        Spacer()
        // This is for the height. Is there a better way to do this?
        SignalComponent()
          .opacity(0)
        Button("Quit") {
          hogRouter.closeShow()
        }
        .buttonStyle(.borderedProminent)
      }
      .padding(.horizontal)
      HStack {
        Spacer()
        SignalComponent()
        Spacer()
      }
    }
  }
}

#Preview {
  @Previewable @State var hogRouter = HogRouter(
    routerDestination: .show(Show.mockShow.id)
  )

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
  .withPreviewEnvironment()
  .environment(hogRouter)
}
