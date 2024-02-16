//
//  PlaybackObjectView.swift
//  iHog
//
//  Created by Jay on 2/16/24.
//

import SwiftUI

struct PlaybackObjectView: View {
  @Environment(\.horizontalSizeClass) var horizontalSizeClass
  @Environment(\.verticalSizeClass) var verticalSizeClass

  @FetchRequest<ShowObjectEntity> var listObjects: FetchedResults<ShowObjectEntity>
  @FetchRequest<ShowObjectEntity> var scenes: FetchedResults<ShowObjectEntity>

  var showID: UUID

  var device = UIDevice.current.userInterfaceIdiom

  init(showID: UUID) {
    _listObjects = FetchRequest(
      fetchRequest: FetchRequestBuilder.getObjects(for: showID, of: .list)
    )
    _scenes = FetchRequest(fetchRequest: FetchRequestBuilder.getObjects(for: showID, of: .scene))
    self.showID = showID
  }

  var body: some View {
    if verticalSizeClass == .regular && horizontalSizeClass == .compact {
      SmallPlaybackObjectsView(showID: showID)
    } else if verticalSizeClass == .regular && horizontalSizeClass == .regular {
      LargePlaybackObjectsView(lists: Array(listObjects), scenes: Array(scenes))
    } else if verticalSizeClass == .compact && horizontalSizeClass == .compact {
      LargePlaybackObjectsView(lists: Array(listObjects), scenes: Array(scenes))
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

struct PlaybackObjectView_Previews: PreviewProvider {
  static var previews: some View {
    PlaybackObjectView(showID: ShowEntity.mock.safeID)
      .environment(\.managedObjectContext, .mock)
      .environment(OSCManager.mock)
      .previewDevice(PreviewDevice(rawValue: "iPhone 15 Pro"))
      .previewDisplayName("iPhone Pro")

    PlaybackObjectView(showID: ShowEntity.mock.safeID)
      .environment(\.managedObjectContext, .mock)
      .environment(OSCManager.mock)
      .previewDevice(PreviewDevice(rawValue: "iPad Pro (12.9-inch)"))
      .previewDisplayName("iPad Pro")
  }
}
