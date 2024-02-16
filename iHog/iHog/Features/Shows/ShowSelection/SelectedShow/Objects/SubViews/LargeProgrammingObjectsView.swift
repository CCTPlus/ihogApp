//
//  LargeProgrammingObjectsView.swift
//  iHog
//
//  Created by Jay on 2/16/24.
//

import SwiftUI

struct LargeProgrammingObjectsView: View {
  @State private var titleHeight: CGFloat = 0
  var groups: [ShowObjectEntity]
  var palettes: [ShowObjectEntity]

  var body: some View {
    HStack {
      ZStack {
        VStack {
          HStack {
            Spacer()
            Text("Groups")
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
          ShowObjectGridView(objects: groups, size: CGSize(width: 100, height: 100))
            .padding(.top)
        }
        .padding(.top, titleHeight)
      }
      ZStack {
        VStack {
          HStack {
            Spacer()
            Text("Palettes")
              .font(.headline)
            Spacer()
          }
          .padding(.vertical)
          .background(Material.bar)
          Spacer()
        }
        ScrollView {
          ShowObjectGridView(objects: palettes, size: CGSize(width: 100, height: 100))
            .padding(.top)
        }
        .padding(.top, titleHeight)
      }
    }
    .toolbar {
      ToolbarItem {
        Button(
          action: { print("Clear") },
          label: {
            Label("Release All", systemImage: "x.square")
          }
        )
      }
    }
  }
}

#Preview {
  NavigationStack {
    LargeProgrammingObjectsView(
      groups: ShowObjectEntity.mock(with: 100, type: .group),
      palettes: ShowObjectEntity.mock(with: 20, type: .intensity)
    )
    .environment(OSCManager.mock)
    .environment(\.managedObjectContext, .mock)
  }
}
