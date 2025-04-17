import SwiftUI

/// A view that displays and manages board items in a layer above the grid.
/// Items are positioned relative to the board's center origin and snap to the grid.
struct BoardItemsLayer: View {
  /// The items to display
  let items: [BoardItem]

  /// The current offset of the viewport from center
  let contentOffset: CGPoint

  var body: some View {
    GeometryReader { geometry in
      ZStack {
        ForEach(items) { item in
          Rectangle()
            .fill(Color.blue)  // TODO: Get color from ShowObject
            .border(Color.red, width: 4)
            .frame(width: item.size.width, height: item.size.height)
            .position(
              x: geometry.size.width / 2 + contentOffset.x + item.position.x,
              y: geometry.size.height / 2 + contentOffset.y + item.position.y
            )
        }
      }
    }
  }
}

#Preview("Edit Mode") {
  BoardItemsLayer(
    items: BoardItemMockRepository.previewWithItems.items,
    contentOffset: .zero
  )
}

#Preview("Play Mode") {
  BoardItemsLayer(
    items: BoardItemMockRepository.previewWithItems.items,
    contentOffset: .zero
  )
}
