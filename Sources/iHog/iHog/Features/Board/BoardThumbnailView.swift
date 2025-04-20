//
//  BoardThumbnailView.swift
//  iHog
//
//  Created by Jay Wilson on 4/20/25.
//

import SwiftUI

/// A view that displays a thumbnail preview of a board.
/// This is a placeholder implementation that will be completed in Step 3.
struct BoardThumbnailView: View {
  /// The board to display in the thumbnail
  let board: Board

  /// The scale factor to apply to the board content
  let scale: CGFloat

  var body: some View {
    Rectangle()
      .fill(Color(.systemGray6))
      .aspectRatio(1, contentMode: .fit)
      .clipShape(RoundedRectangle(cornerRadius: 12))
      .overlay(
        RoundedRectangle(cornerRadius: 12)
          .stroke(Color(.systemGray4), lineWidth: 1)
      )
  }
}

#Preview {
  BoardThumbnailView(
    board: Board(
      id: UUID(),
      name: "Preview Board",
      showID: UUID(),
      lastPanOffset: .zero,
      lastZoomScale: 1.0,
      dateLastModified: Date()
    ),
    scale: 0.2
  )
  .frame(width: 160, height: 160)
  .padding()
}
