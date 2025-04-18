import SwiftUI
import UIKit

/// A container view that provides an infinite scrollable area for board items.
/// The view maintains a center origin coordinate system and manages multiple layers:
/// - Grid layer (back)
/// - Gesture Handler when in edit mode
/// - Board Items layer (front)
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
          if viewModel.boardState.isEditMode == false {
            TwoFingerPanGesture(
              sensitivity: 0.75,
              onChanged: { translation in
                viewModel.updateOffset(
                  to: CGPoint(
                    x: viewModel.totalOffset.x + translation.x,
                    y: viewModel.totalOffset.y + translation.y
                  )
                )
              },
              onEnded: { _ in }
            )
          }
          // Grid layer (back)
          if viewModel.boardState.isGridVisible {
            GridView(
              size: geometry.size,
              zoomLevel: viewModel.totalScale,
              scrollOffset: .zero,
              contentOffset: viewModel.totalOffset
            )
          }

          if viewModel.boardState.isEditMode {
            // Unified gesture handler
            UnifiedGestureHandler(geometry: geometry)
              .environment(viewModel)
          }

          BoardItemsLayer(
            items: viewModel.items,
            contentOffset: viewModel.totalOffset,
            showObjectRepository: showObjectRepository
          )
          .environment(viewModel)
        }
        .ignoresSafeArea(edges: .all)
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
      .sheet(isPresented: $viewModel.showingObjectSelection) {
        ObjectSelectionMenu(
          repository: showObjectRepository
            ?? ShowObjectSwiftDataRepository(modelContainer: modelContext.container),
          showID: viewModel.board.showID,
          onSelect: viewModel.handleObjectSelection
        )
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
