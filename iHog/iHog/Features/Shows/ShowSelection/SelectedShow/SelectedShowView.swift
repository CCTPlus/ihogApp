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

  @FetchRequest<ShowEntity>
  var shows: FetchedResults<ShowEntity>

  init(showID: UUID) {
    _shows = FetchRequest(fetchRequest: FetchRequestBuilder.getShow(with: showID))
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
                showRouter.show(sheet: .newObject)
              }
            case .hardwarePlayback:
              Text("🤷‍♂️")
            case .hardwareProg:
              Button("Encoders", systemImage: "cooktop") {
                showRouter.show(sheet: .encoder)
              }
          }
        }
      }
      .sheet(
        item: $showRouter.sheetShown,
        onDismiss: {
          moc.reset()
        }
      ) { sheet in
        if let show = shows.first {
          sheet.view(show: show)
        } else {
          Text("You should never see this")
        }
      }
  }
}

#Preview {
  NavigationStack {
    SelectedShowView(showID: FixtureConstants.uuid1)
      .environment(\.managedObjectContext, .mock)
      .environment(OSCManager.mock)
  }
}
