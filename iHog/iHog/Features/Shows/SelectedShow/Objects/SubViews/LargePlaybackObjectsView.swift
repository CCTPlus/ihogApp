//
//  LargePlaybackObjectsView.swift
//  iHog
//
//  Created by Jay on 2/16/24.
//

import SwiftUI

struct LargePlaybackObjectsView: View {
  @State private var titleHeight: CGFloat = 0
  var lists: [ShowObjectEntity]
  var scenes: [ShowObjectEntity]

  var body: some View {
    HStack {
      ZStack {
        VStack {
          HStack {
            Spacer()
            Text("Lists")
              .font(.headline)
            Spacer()
          }
          .padding(.vertical)
          .background(Material.bar)
          .heightChangePreference { height in
            titleHeight = height
          }

          Spacer()
        }
        ScrollView {
          ShowObjectGridView(objects: lists, size: CGSize(width: 100, height: 100))
            .padding(.top)
        }
        .padding(.top, titleHeight)
      }
      ZStack {
        VStack {
          HStack {
            Spacer()
            Text("Scenes")
              .font(.headline)
            Spacer()
          }
          .padding(.vertical)
          .background(Material.bar)
          Spacer()
        }
        ScrollView {
          ShowObjectGridView(objects: scenes, size: CGSize(width: 100, height: 100))
            .padding(.top)
        }
        .padding(.top, titleHeight)
      }
    }
    .toolbar {
      ToolbarItem {
        Button(
          action: { print("release all") },
          label: {
            Label("Release All", systemImage: "stop")
          }
        )
      }
    }
  }
}

#Preview {
  NavigationStack {
    LargePlaybackObjectsView(
      lists: ShowObjectEntity.mock(with: 100),
      scenes: ShowObjectEntity.mock(with: 20, type: .scene)
    )
    .environment(OSCManager.mock)
    .environment(\.managedObjectContext, .mock)
  }
}
