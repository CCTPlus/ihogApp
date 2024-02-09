//
//  SelectedShowView.swift
//  iHog
//
//  Created by Jay on 1/21/24.
//

import SwiftUI

struct SelectedShowView: View {
  @Environment(\.managedObjectContext) var moc
  @Environment(OSCManager.self) var oscManager

  @State var showRouter = ShowRouter()

  var showRequest: FetchRequest<ShowEntity>
  var shows: FetchedResults<ShowEntity> { showRequest.wrappedValue }

  init(showID: UUID) {
    showRequest = FetchRequest(fetchRequest: FetchRequestBuilder.getShow(with: showID))
  }
  var body: some View {
    showRouter.selectedView.view(showID: shows.first?.safeID ?? UUID())
      .environment(oscManager)
      .navigationTitle(Text(shows.first?.viewName ?? "Test"))
      .navigationBarTitleDisplayMode(.inline)
      .toolbar {
        ToolbarTitleMenu {
          ShowMenu(showRouter: showRouter)
        }
        ToolbarItem(placement: .primaryAction) {
          switch showRouter.selectedView {
            case .programming, .playback:
              Button("Add", systemImage: "plus") {
                print("Show add object sheet")
              }
            case .hardwarePlayback:
              Text("🤷‍♂️")
            case .hardwareProg:
              Text("🤷‍♂️")
          }
        }
      }
  }
}

#if DEBUG
  #Preview {
    NavigationStack {
      SelectedShowView(showID: FixtureConstants.uuid1)
        .environment(\.managedObjectContext, .mock)
        .environment(OSCManager.mock)
    }
  }
#endif
