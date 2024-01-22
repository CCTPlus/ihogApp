//
//  SelectedShowView.swift
//  iHog
//
//  Created by Jay on 1/21/24.
//

import SwiftUI

struct SelectedShowView: View {
  @Environment(\.managedObjectContext) var moc

  @State var showRouter = ShowRouter()

  var showRequest: FetchRequest<ShowEntity>
  var shows: FetchedResults<ShowEntity> { showRequest.wrappedValue }

  init(showID: UUID) {
    showRequest = FetchRequest(fetchRequest: FetchRequestBuilder.getShow(with: showID))
  }
  var body: some View {
    showRouter.selectedView.view
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
  }
}
