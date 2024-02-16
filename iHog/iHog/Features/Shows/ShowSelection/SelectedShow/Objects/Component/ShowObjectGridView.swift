//
//  ShowObjectGridView.swift
//  iHog
//
//  Created by Jay on 2/9/24.
//

import SwiftUI

struct ShowObjectGridView: View {
  var objects: [ShowObjectEntity]
  var size: CGSize

  let columns: [GridItem]

  init(
    objects: [ShowObjectEntity],
    size: CGSize,
    columns: [GridItem] = GridConstant.objectGrid(width: 100)
  ) {
    self.objects = objects
    self.size = size
    self.columns = GridConstant.objectGrid(width: size.width)
  }

  var body: some View {
    LazyVGrid(columns: columns) {
      ForEach(objects, id: \.id) { obj in
        ShowObjectView(showObject: obj, size: size)
      }
    }
  }
}

#Preview {
  ShowObjectGridView(objects: ShowObjectEntity.mock(with: 4), size: CGSize(width: 80, height: 80))
    .environment(OSCManager.mock)
}
