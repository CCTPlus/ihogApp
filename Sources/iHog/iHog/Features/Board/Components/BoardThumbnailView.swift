import SwiftUI

/// A view that displays a thumbnail preview for a board.
/// Currently uses a system image as a placeholder.
struct BoardThumbnailView: View {
  var body: some View {
    Image(systemName: "rectangle.grid.2x2")
      .font(.title)
      .foregroundColor(.secondary)
      .frame(width: 44, height: 44)
  }
}

#Preview {
  BoardThumbnailView()
}
