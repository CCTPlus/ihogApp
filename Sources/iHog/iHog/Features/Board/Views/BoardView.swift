import SwiftUI

/// A container view that provides an infinite scrollable area for board items.
/// The view maintains a center origin coordinate system and manages multiple layers:
/// - Grid layer (back)
/// - Board Items layer (middle)
/// - Board UI layer (front)
struct BoardView: View {
  @Environment(\.modelContext) private var modelContext
  @Environment(\.dismiss) private var dismiss
  /// The view model that manages the board's state and behavior
  @State var viewModel: BoardViewModel

  /// The current gesture translation
  @GestureState private var gestureTranslation: CGSize = .zero

  /// The current total offset (stored + gesture)
  private var totalOffset: CGPoint {
    CGPoint(
      x: viewModel.boardState.contentOffset.x + gestureTranslation.width,
      y: viewModel.boardState.contentOffset.y + gestureTranslation.height
    )
  }

  var showObjectRepository: ShowObjectRepository? = nil

  var body: some View {
    NavigationStack {
      GeometryReader { geometry in
        ZStack {
          // Background layer to capture gestures
          Color.clear
            .contentShape(Rectangle())

          // Grid layer (back)
          if viewModel.boardState.isGridVisible {
            GridView(
              size: geometry.size,
              zoomLevel: viewModel.boardState.zoomLevel,
              scrollOffset: .zero,
              contentOffset: totalOffset
            )
          }

          // Board Items layer (middle)
          BoardItemsLayer(
            items: viewModel.items,
            contentOffset: totalOffset,
            showObjectRepository: showObjectRepository
          )
          .environment(viewModel)
        }
        .ignoresSafeArea(edges: .all)
        .gesture(
          DragGesture(minimumDistance: 0)
            .updating($gestureTranslation) { value, state, _ in
              state = value.translation
            }
            .onEnded { value in
              let newOffset = CGPoint(
                x: viewModel.boardState.contentOffset.x + value.translation.width,
                y: viewModel.boardState.contentOffset.y + value.translation.height
              )
              viewModel.updateOffset(to: newOffset)
            }
        )
      }
      .toolbarRole(.navigationStack)
      .toolbarTitleDisplayMode(.inline)
      .toolbarBackground(.hidden, for: .navigationBar)
      .toolbar {
        ToolbarItemGroup(placement: .topBarLeading) {
          Button {
            dismiss()
          } label: {
            Image(systemName: "xmark")
          }

          Button(action: {
            viewModel.updateOffset(to: .zero)
          }) {
            Image(systemName: "scope")
          }
        }

        ToolbarItem(placement: .principal) {
          Text(viewModel.board.name)
            .font(.headline)
        }

        ToolbarItemGroup(placement: .topBarTrailing) {
          if viewModel.boardState.isEditMode {
            Button(action: {
              viewModel.undoManager?.undo()
            }) {
              Image(systemName: "arrow.uturn.backward")
            }
            .disabled(!(viewModel.undoManager?.canUndo ?? false))

            Button(action: {
              viewModel.undoManager?.redo()
            }) {
              Image(systemName: "arrow.uturn.forward")
            }
            .disabled(!(viewModel.undoManager?.canRedo ?? false))
          }

          Button(action: viewModel.toggleEditMode) {
            Image(systemName: viewModel.boardState.isEditMode ? "pencil" : "play.fill")
          }
        }
      }
    }
  }
}

#Preview("Edit Mode") {
  BoardView(
    viewModel: BoardViewModel(
      board: BoardMockRepository.previewWithBoards.boards[0],
      boardState: BoardState(isEditMode: true),
      repository: BoardMockRepository.previewWithBoards,
      itemRepository: BoardItemMockRepository.previewWithItems,
      items: BoardItemMockRepository.previewWithItems.items
    ),
    showObjectRepository: ShowObjectMockRepository.preview
  )
}

#Preview("Play Mode") {
  BoardView(
    viewModel: BoardViewModel(
      board: BoardMockRepository.previewWithBoards.boards[0],
      boardState: BoardState(isEditMode: false),
      repository: BoardMockRepository.previewWithBoards,
      itemRepository: BoardItemMockRepository.previewWithItems,
      items: BoardItemMockRepository.previewWithItems.items
    ),
    showObjectRepository: ShowObjectMockRepository.preview
  )
}
