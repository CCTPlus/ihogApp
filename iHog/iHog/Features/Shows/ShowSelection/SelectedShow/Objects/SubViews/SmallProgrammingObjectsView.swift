//
//  ProgrammingObjectsView.swift
//  iHog
//
//  Created by Jay on 2/9/24.
//

import SwiftUI

struct SmallProgrammingObjectsView: View {
  @Environment(\.managedObjectContext) var moc

  @FetchRequest<ShowObjectEntity> var groups: FetchedResults<ShowObjectEntity>
  @FetchRequest<ShowObjectEntity> var palettes: FetchedResults<ShowObjectEntity>

  init(showID: UUID) {
    _groups = FetchRequest(
      fetchRequest: FetchRequestBuilder.getObjects(for: showID, of: .group)
    )
    _palettes = FetchRequest(
      fetchRequest: FetchRequestBuilder.getObjects(
        for: showID,
        of: .intensity,
        .position,
        .color,
        .beam,
        .effect
      )
    )
  }

  var body: some View {
    ScrollView {
      Text("Groups")
      ShowObjectGridView(objects: Array(groups), size: CGSize(width: 100, height: 100))
        .id("lists")
      Text("Palettes")
      ShowObjectGridView(objects: Array(palettes), size: CGSize(width: 100, height: 100))
        .id("scenes")
    }
  }
}

#Preview {
  SmallProgrammingObjectsView(showID: ShowEntity.mock.safeID)
    .environment(\.managedObjectContext, .mock)
    .environment(OSCManager.mock)
}
