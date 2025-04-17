import SwiftUI

/// A container view that provides an infinite scrollable area for board items.
/// The view maintains a center origin coordinate system and manages multiple layers:
/// - Grid layer (back)
/// - Board Items layer (middle)
/// - Board UI layer (front)
struct BoardView: View {
  /// The view model that manages the board's state and behavior
  @Bindable var viewModel: BoardViewModel

  /// The current pan offset
  @State private var panOffset: CGPoint = .zero

  /// The current gesture translation
  @GestureState private var gestureTranslation: CGSize = .zero

  /// The current total offset (stored + gesture)
  private var totalOffset: CGPoint {
    CGPoint(
      x: panOffset.x + gestureTranslation.width,
      y: panOffset.y + gestureTranslation.height
    )
  }

  var body: some View {
    NavigationStack {
      GeometryReader { geometry in
        ZStack {
          // Grid layer (back)
          if viewModel.boardState.isGridVisible {
            GridView(
              size: geometry.size,
              zoomLevel: viewModel.boardState.zoomLevel,
              scrollOffset: .zero,
              contentOffset: totalOffset
            )
          }
        }
        .gesture(
          DragGesture(minimumDistance: 0)
            .updating($gestureTranslation) { value, state, _ in
              state = value.translation
            }
            .onEnded { value in
              panOffset = CGPoint(
                x: panOffset.x + value.translation.width,
                y: panOffset.y + value.translation.height
              )
            }
        )
      }
      .toolbarRole(.navigationStack)
      .toolbarTitleDisplayMode(.inline)
      .toolbarBackground(.hidden, for: .navigationBar)
      .toolbar {
        ToolbarItem(placement: .navigationBarLeading) {
          Button(action: {}) {
            Image(systemName: "xmark")
          }
        }

        ToolbarItem(placement: .principal) {
          Text(viewModel.board.name)
            .font(.headline)
        }

        ToolbarItemGroup(placement: .navigationBarTrailing) {
          Button(action: {}) {
            Image(systemName: "arrow.uturn.backward")
          }

          Button(action: {}) {
            Image(systemName: "arrow.uturn.forward")
          }

          Button(action: viewModel.toggleEditMode) {
            Image(systemName: viewModel.boardState.isEditMode ? "pencil" : "play.fill")
          }
        }
      }
    }
  }
}

#Preview {
  BoardView(
    viewModel: BoardViewModel(
      board: BoardMockRepository.previewWithBoards.boards[0],
      boardState: BoardState(isEditMode: true),
      repository: BoardMockRepository.previewWithBoards
    )
  )
}
