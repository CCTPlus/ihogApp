//
//  BoardGridView.swift
//  iHog
//
//  Created by Jay Wilson on 4/20/25.
//

import SwiftUI

struct BoardGridView: View {
  let panOffset: CGPoint

  var body: some View {
    Canvas { context, size in
      let gridSize = BoardViewModel.gridUnitSize
      let offsetX = panOffset.x.truncatingRemainder(dividingBy: gridSize)
      let offsetY = panOffset.y.truncatingRemainder(dividingBy: gridSize)

      for x in stride(from: -gridSize, through: size.width + gridSize, by: gridSize) {
        for y in stride(from: -gridSize, through: size.height + gridSize, by: gridSize) {
          let dot = Path { path in
            path.addEllipse(
              in: CGRect(
                x: x - offsetX - 2,
                y: y - offsetY - 2,
                width: 4,
                height: 4
              )
            )
          }
          context.fill(dot, with: .color(Color(.systemGray4)))
        }
      }
    }
  }
}

#Preview {
  BoardGridView(panOffset: .zero)
    .frame(width: 300, height: 300)
    .border(Color.gray)
}
