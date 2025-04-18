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

  /// The current gesture scale
  @GestureState private var gestureScale: CGFloat = 1.0

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
              zoomLevel: viewModel.totalScale * gestureScale,
              scrollOffset: .zero,
              contentOffset: CGPoint(
                x: viewModel.totalOffset.x + gestureTranslation.width,
                y: viewModel.totalOffset.y + gestureTranslation.height
              )
            )
            .animation(.easeInOut(duration: 0.2), value: viewModel.totalScale * gestureScale)
          }

          // Board Items layer (middle)
          BoardItemsLayer(
            items: viewModel.items,
            contentOffset: CGPoint(
              x: viewModel.totalOffset.x + gestureTranslation.width,
              y: viewModel.totalOffset.y + gestureTranslation.height
            ),
            showObjectRepository: showObjectRepository
          )
          .environment(viewModel)
          .animation(.easeInOut(duration: 0.2), value: viewModel.totalScale * gestureScale)
        }
        .ignoresSafeArea(edges: .all)
        .gesture(
          SimultaneousGesture(
            // Pan gesture
            DragGesture(minimumDistance: 0)
              .updating($gestureTranslation) { value, state, _ in
                state = value.translation
              }
              .onEnded { value in
                withAnimation(.easeInOut(duration: 0.2)) {
                  viewModel.handlePanGesture(value)
                }
              },
            // Zoom gesture
            MagnificationGesture()
              .updating($gestureScale) { value, state, _ in
                state = value
              }
              .onEnded { value in
                withAnimation(.easeInOut(duration: 0.2)) {
                  viewModel.handleZoomGesture(value)
                }
              }
          )
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
            withAnimation(.easeInOut(duration: 0.2)) {
              viewModel.updateOffset(to: .zero)
            }
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
