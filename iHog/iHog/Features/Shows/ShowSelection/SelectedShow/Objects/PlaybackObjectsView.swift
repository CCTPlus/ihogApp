//
//  PlaybackObjectsView.swift
//  iHog
//
//  Created by Jay on 2/9/24.
//

import SwiftUI

struct PlaybackObjectsView: View {
  @Environment(\.managedObjectContext) var moc

  @FetchRequest<ShowObjectEntity> var listObjects: FetchedResults<ShowObjectEntity>
  @FetchRequest<ShowObjectEntity> var scenes: FetchedResults<ShowObjectEntity>

  init(showID: UUID) {
    _listObjects = FetchRequest(
      fetchRequest: FetchRequestBuilder.getObjects(for: showID, of: .list)
    )
    _scenes = FetchRequest(fetchRequest: FetchRequestBuilder.getObjects(for: showID, of: .scene))
  }

  var body: some View {
    ScrollView {
      ShowObjectGridView(objects: Array(listObjects), size: CGSize(width: 100, height: 100))
        .id("lists")
      ShowObjectGridView(objects: Array(scenes), size: CGSize(width: 100, height: 100))
        .id("scenes")
    }
  }
}

#Preview {
  PlaybackObjectsView(showID: ShowEntity.mock.safeID)
    .environment(\.managedObjectContext, .mock)
    .environment(OSCManager.mock)
}
