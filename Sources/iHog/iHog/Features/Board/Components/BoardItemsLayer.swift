import SwiftUI

/// Layer responsible for rendering board items with proper positioning and scaling.
/// - Maintains center origin coordinate system regardless of viewport size
/// - Handles translation of item positions from model space to view space
/// - Ensures items stay correctly positioned during pan and zoom operations
struct BoardItemsLayer: View {
  @Environment(\.modelContext) private var modelContext
  /// Board items in model coordinates (0,0 is board center)
  let items: [BoardItem]

  /// Pan offset from board center in points, used to translate model coordinates to view space
  let contentOffset: CGPoint

  /// Shared view model providing edit state and zoom level to child BoardItemViews
  @Environment(BoardViewModel.self) private var viewModel

  var body: some View {
    GeometryReader { geometry in
      ForEach(items) { item in
        BoardItemView(
          item: item,
          isEditMode: viewModel.boardState.isEditMode,
          zoomLevel: viewModel.boardState.zoomLevel
        )
        .position(
          x: geometry.size.width / 2 + contentOffset.x + item.position.x,
          y: geometry.size.height / 2 + contentOffset.y + item.position.y
        )
      }
    }
  }
}

#Preview("Edit Mode") {
  @Previewable @State var viewModel = BoardViewModel(
    board: BoardMockRepository.previewWithBoards.boards[0],
    boardState: BoardState(isEditMode: true),
    repository: BoardMockRepository.previewWithBoards,
    itemRepository: BoardItemMockRepository.previewWithItems
  )

  return BoardItemsLayer(
    items: BoardItemMockRepository.previewWithItems.items,
    contentOffset: .zero
  )
  .environment(viewModel)
}

#Preview("Play Mode") {
  @Previewable @State var viewModel = BoardViewModel(
    board: BoardMockRepository.previewWithBoards.boards[0],
    boardState: BoardState(isEditMode: false),
    repository: BoardMockRepository.previewWithBoards,
    itemRepository: BoardItemMockRepository.previewWithItems
  )

  return BoardItemsLayer(
    items: BoardItemMockRepository.previewWithItems.items,
    contentOffset: .zero
  )
  .environment(viewModel)
}
