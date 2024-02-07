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
    showRouter.selectedView.view
      .environment(oscManager)
      .navigationTitle(Text(shows.first?.viewName ?? "Test"))
      .navigationBarTitleDisplayMode(.inline)
      .toolbar {
        ToolbarTitleMenu {
          ShowMenu(showRouter: showRouter)
        }
      }
  }
}

#Preview {
  NavigationStack {
    SelectedShowView(showID: FixtureConstants.uuid1!)
      .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
      .environment(OSCManager(outputPort: 9000, consoleInputPort: 9001))
  }
}
