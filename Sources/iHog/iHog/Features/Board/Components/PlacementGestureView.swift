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
          .overlay(
            PlacementGestureRecognizerView(
              onChanged: { location in
                // Snap to grid dots (not cell centers)
                let snappedViewPoint = CGPoint(
                  x: round((location.x - gridSize / 2) / gridSize) * gridSize + gridSize / 2,
                  y: round((location.y - gridSize / 2) / gridSize) * gridSize + gridSize / 2
                )

                // Then convert to board coordinates
                let boardLocation = CGPoint(
                  x: snappedViewPoint.x - geometry.size.width / 2 - viewModel.totalOffset.x,
                  y: snappedViewPoint.y - geometry.size.height / 2 - viewModel.totalOffset.y
                )

                if viewModel.placementDragState == .inactive {
                  // Start new drag immediately at the exact snapped point
                  startPosition = boardLocation
                  currentPosition = boardLocation
                  viewModel.startPlacement()
                  viewModel.updatePlacementDragState(.valid)
                } else {
                  // Update current position
                  currentPosition = boardLocation

                  // Calculate the rectangle
                  let rect = calculateRectangle()

                  // Validate size (must be at least one grid unit)
                  let isValid = rect.width >= gridSize && rect.height >= gridSize

                  // Validate position
                  let wouldOverlap = viewModel.wouldOverlap(rect)

                  viewModel.updatePlacementDragState(isValid && !wouldOverlap ? .valid : .invalid)
                }
              },
              onEnded: {
                if viewModel.placementDragState == .valid {
                  // Calculate final rectangle
                  let rect = calculateRectangle()

                  // Show object selection menu
                  viewModel.prepareToAddItem(at: rect)
                }

                // Reset drag state
                viewModel.endPlacement()
              }
            )
          )

        // Visual feedback rectangle
        if viewModel.placementDragState != .inactive {
          let rect = calculateRectangle()
          let coordinateSystem = BoardCoordinateSystem(
            viewportSize: geometry.size,
            contentOffset: viewModel.totalOffset
          )
          Rectangle()
            .fill(
              viewModel.placementDragState == .valid
                ? Color.gray.opacity(0.3) : Color.red.opacity(0.3)
            )
            .frame(width: rect.width, height: rect.height)
            .offset(x: rect.width / 2, y: rect.height / 2)
            .position(
              x: coordinateSystem.viewPosition(for: rect.origin).x,
              y: coordinateSystem.viewPosition(for: rect.origin).y
            )
        }
      }
    }
  }

  /// Calculates the rectangle in grid-aligned coordinates
  private func calculateRectangle() -> CGRect {
    // Use the already-snapped positions directly
    let width = abs(currentPosition.x - startPosition.x)
    let height = abs(currentPosition.y - startPosition.y)
    let x = min(startPosition.x, currentPosition.x)
    let y = min(startPosition.y, currentPosition.y)

    return CGRect(x: x, y: y, width: width, height: height)
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
