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
            .position(coordinateSystem.viewPosition(for: rect.center))
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

              // Calculate the rectangle
              let rect = calculateRectangle()

              // Validate size (must be at least one grid unit)
              let isValid = rect.width >= gridSize && rect.height >= gridSize

              // Validate position
              let wouldOverlap = viewModel.wouldOverlap(rect)

              // Debug logging
              print("Rectangle size: \(rect.width) x \(rect.height)")
              print("Grid size: \(gridSize)")
              print("Is valid size: \(isValid)")
              print("Would overlap: \(wouldOverlap)")
              print("Items on board: \(viewModel.items.count)")

              viewModel.updatePlacementDragState(isValid && !wouldOverlap ? .valid : .invalid)
            }
          }
          .onEnded { _ in
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
    }
  }

  /// Snaps a point to the nearest grid intersection
  private func snapToGrid(_ point: CGPoint) -> CGPoint {
    CGPoint(
      x: round(point.x / gridSize) * gridSize,
      y: round(point.y / gridSize) * gridSize
    )
  }

  /// Calculates the rectangle in grid-aligned coordinates
  private func calculateRectangle() -> CGRect {
    // Calculate width and height, ensuring they're grid-aligned
    let width = round(abs(currentPosition.x - startPosition.x) / gridSize) * gridSize
    let height = round(abs(currentPosition.y - startPosition.y) / gridSize) * gridSize

    // Calculate position, ensuring we're aligned to grid
    let x = round(min(startPosition.x, currentPosition.x) / gridSize) * gridSize
    let y = round(min(startPosition.y, currentPosition.y) / gridSize) * gridSize

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
