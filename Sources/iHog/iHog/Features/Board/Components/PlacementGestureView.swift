import SwiftUI

/// A view that handles the placement gesture system for adding new board items.
/// This view overlays the board and provides visual feedback during drag operations.
struct PlacementGestureView: View {
  @Environment(BoardViewModel.self) private var viewModel

  /// The start position of the drag in board coordinates
  @State private var startPosition: CGPoint = .zero

  /// The current drag position in board coordinates
  @State private var currentPosition: CGPoint = .zero

  /// The grid size in points
  private let gridSize: CGFloat = 44.0

  var body: some View {
    GeometryReader { geometry in
      ZStack {
        // Background layer to capture initial drag
        Color.clear
          .contentShape(Rectangle())
          .frame(maxWidth: .infinity, maxHeight: .infinity)

        // Visual feedback rectangle
        if viewModel.placementDragState != .inactive {
          Rectangle()
            .fill(
              viewModel.placementDragState == .valid
                ? Color.gray.opacity(0.3) : Color.red.opacity(0.3)
            )
            .frame(
              width: abs(currentPosition.x - startPosition.x),
              height: abs(currentPosition.y - startPosition.y)
            )
            .position(
              x: geometry.size.width / 2 + viewModel.totalOffset.x
                + (startPosition.x + currentPosition.x) / 2,
              y: geometry.size.height / 2 + viewModel.totalOffset.y
                + (startPosition.y + currentPosition.y) / 2
            )
        }
      }
      .gesture(
        DragGesture(minimumDistance: 0)
          .onChanged { value in
            // Convert drag location to board coordinates
            let location = CGPoint(
              x: value.location.x - geometry.size.width / 2 - viewModel.totalOffset.x,
              y: value.location.y - geometry.size.height / 2 - viewModel.totalOffset.y
            )

            if viewModel.placementDragState == .inactive {
              // Start new drag
              startPosition = snapToGrid(location)
              currentPosition = startPosition
              viewModel.startPlacement()
            } else {
              // Update current position
              currentPosition = snapToGrid(location)

              // Validate size
              let width = abs(currentPosition.x - startPosition.x)
              let height = abs(currentPosition.y - startPosition.y)
              let isValid = width >= gridSize && height >= gridSize

              // Validate position
              let rect = CGRect(
                x: min(startPosition.x, currentPosition.x),
                y: min(startPosition.y, currentPosition.y),
                width: width,
                height: height
              )
              let wouldOverlap = viewModel.wouldOverlap(rect)

              viewModel.updatePlacementDragState(isValid && !wouldOverlap ? .valid : .invalid)
            }
          }
          .onEnded { _ in
            if viewModel.placementDragState == .valid {
              // Calculate final rectangle
              let rect = CGRect(
                x: min(startPosition.x, currentPosition.x),
                y: min(startPosition.y, currentPosition.y),
                width: abs(currentPosition.x - startPosition.x),
                height: abs(currentPosition.y - startPosition.y)
              )

              // Show object selection menu
              viewModel.prepareToAddItem(at: rect)
            }

            // Reset drag state
            viewModel.endPlacement()
          }
      )
    }
  }

  /// Snaps a point to the nearest grid intersection
  private func snapToGrid(_ point: CGPoint) -> CGPoint {
    CGPoint(
      x: round(point.x / gridSize) * gridSize,
      y: round(point.y / gridSize) * gridSize
    )
  }
}

/// The possible states of a drag operation
private enum DragState {
  case inactive
  case valid
  case invalid
}

#Preview("Valid Drag") {
  @Previewable @State var viewModel = BoardViewModel(
    board: BoardMockRepository.previewWithBoards.boards[0],
    boardState: BoardState(isEditMode: true),
    repository: BoardMockRepository.previewWithBoards,
    itemRepository: BoardItemMockRepository.previewWithItems
  )

  return PlacementGestureView()
    .environment(viewModel)
    .frame(width: 400, height: 400)
}

#Preview("Invalid Drag") {
  @Previewable @State var viewModel = BoardViewModel(
    board: BoardMockRepository.previewWithBoards.boards[0],
    boardState: BoardState(isEditMode: true),
    repository: BoardMockRepository.previewWithBoards,
    itemRepository: BoardItemMockRepository.previewWithItems
  )

  return PlacementGestureView()
    .environment(viewModel)
    .frame(width: 400, height: 400)
}
