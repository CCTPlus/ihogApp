//
//  ProgrammingObjectsView.swift
//  iHog
//
//  Created by Jay on 2/16/24.
//

import SwiftUI

struct ProgrammingObjectsView: View {
  @Environment(\.horizontalSizeClass) var horizontalSizeClass
  @Environment(\.verticalSizeClass) var verticalSizeClass

  @FetchRequest<ShowObjectEntity> var groupObjects: FetchedResults<ShowObjectEntity>
  @FetchRequest<ShowObjectEntity> var paletteObjects: FetchedResults<ShowObjectEntity>

  var showID: UUID

  var device = UIDevice.current.userInterfaceIdiom

  init(showID: UUID) {
    _groupObjects = FetchRequest(
      fetchRequest: FetchRequestBuilder.getObjects(for: showID, of: .group)
    )
    _paletteObjects = FetchRequest(
      fetchRequest: FetchRequestBuilder.getObjects(
        for: showID,
        of: .intensity,
        .position,
        .color,
        .beam,
        .effect
      )
    )
    self.showID = showID
  }

  var body: some View {
    if verticalSizeClass == .regular && horizontalSizeClass == .compact {
      SmallProgrammingObjectsView(showID: showID)
    } else if verticalSizeClass == .regular && horizontalSizeClass == .regular {
      LargeProgrammingObjectsView(groups: Array(groupObjects), palettes: Array(paletteObjects))
    } else if verticalSizeClass == .compact && horizontalSizeClass == .compact {
      LargeProgrammingObjectsView(groups: Array(groupObjects), palettes: Array(paletteObjects))
    } else {
      VStack {
        #if DEBUG
          Text("Vertical size: \(verticalSizeClass == .regular ? "regular" : "compact")")
          Text("Horizontal size: \(horizontalSizeClass == .regular ? "regular" : "compact")")
        #endif
        Text("⚠️")
          .font(.largeTitle)
        Text("You shouldn't see this!")
        Link(
          destination: URL(string: "mailto:support@cctplus.dev?subject=Invalid Screen in iHog")!,
          label: {
            Label("Email Jay and let him know", systemImage: "envelope")
          }
        )
      }
    }
  }
}

#Preview {
  ProgrammingObjectsView(showID: ShowEntity.mock.safeID)
    .environment(\.managedObjectContext, .mock)
    .environment(OSCManager.mock)
}
