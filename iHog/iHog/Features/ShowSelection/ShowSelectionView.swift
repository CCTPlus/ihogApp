//
//  ShowSelectionView.swift
//  iHog
//
//  Created by Jay Wilson on 12/6/24.
//

import SwiftData
import SwiftUI

/// Presents all views in a list so that a user can select one. Uses SwiftData to present the list so it needs to only work on iOS 17
@available(iOS 17.0, *)
struct ShowSelectionView: View {
  @Query private var shows: [ShowEntity]

  var body: some View {
    Group {
      ForEach(shows) { show in
        HStack {
          Image(systemName: show.icon ?? "folder")
          Text(show.name)
        }
      }
    }
  }
}

#if DEBUG
  #Preview {
    if #available(iOS 17.0, *) {
      List {
        ShowSelectionView()
      }
      .modelContainer(ShowEntity.preview)
    } else {
      // Fallback on earlier versions
      Text("This show selection view is unusable on iOS 16.")
    }
  }
#endif
