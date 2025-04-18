import SwiftUI
import UIKit

/// A unified gesture handler that manages both placement and panning gestures through UIKit
struct UnifiedGestureHandler: View {
  @Environment(BoardViewModel.self) private var viewModel
  let geometry: GeometryProxy

  /// The start position of the drag in board coordinates
  @State private var startPosition: CGPoint = .zero

  /// The current drag position in board coordinates
  @State private var currentPosition: CGPoint = .zero

  /// The grid size in points
  private let gridSize: CGFloat = 44.0

  var body: some View {
    ZStack {
      // The actual gesture handler
      GestureHandlerView(
        geometry: geometry,
        startPosition: $startPosition,
        currentPosition: $currentPosition
      )
      .environment(viewModel)

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

private struct GestureHandlerView: UIViewRepresentable {
  @Environment(BoardViewModel.self) private var viewModel
  let geometry: GeometryProxy
  @Binding var startPosition: CGPoint
  @Binding var currentPosition: CGPoint
  let gridSize: CGFloat = 44.0

  func makeCoordinator() -> Coordinator {
    Coordinator(self)
  }

  func makeUIView(context: Context) -> UIView {
    let view = UIView()
    view.isUserInteractionEnabled = true
    view.isMultipleTouchEnabled = true

    let panGesture = UIPanGestureRecognizer(
      target: context.coordinator,
      action: #selector(Coordinator.handlePan(_:))
    )
    panGesture.delegate = context.coordinator
    view.addGestureRecognizer(panGesture)

    return view
  }

  func updateUIView(_ uiView: UIView, context: Context) {}

  class Coordinator: NSObject, UIGestureRecognizerDelegate {
    let parent: GestureHandlerView
    var isPlacementActive = false
    var wasTwoFingerPan = false

    init(_ parent: GestureHandlerView) {
      self.parent = parent
    }

    @objc func handlePan(_ gesture: UIPanGestureRecognizer) {
      let touchCount = gesture.numberOfTouches

      // Track if this was a two-finger gesture
      if touchCount == 2 && gesture.state == .began {
        wasTwoFingerPan = true
      }

      // Two finger pan handling
      if touchCount == 2 {
        let translation = gesture.translation(in: gesture.view)
        parent.viewModel.updateOffset(
          to: CGPoint(
            x: parent.viewModel.totalOffset.x + translation.x,
            y: parent.viewModel.totalOffset.y + translation.y
          )
        )
        gesture.setTranslation(.zero, in: gesture.view)

        // Reset when two-finger pan ends
        if gesture.state == .ended || gesture.state == .cancelled {
          wasTwoFingerPan = false
        }
        return
      }

      // Skip placement handling if this was a two-finger gesture
      if wasTwoFingerPan {
        if gesture.state == .ended || gesture.state == .cancelled {
          wasTwoFingerPan = false
        }
        return
      }

      // Single finger placement handling in edit mode
      if parent.viewModel.boardState.isEditMode {
        if touchCount == 1 || (gesture.state == .ended && isPlacementActive) {
          let location = gesture.location(in: gesture.view)
          let size = gesture.view?.bounds.size ?? .zero

          // Snap to grid dots (not cell centers)
          let snappedViewPoint = CGPoint(
            x: round((location.x - parent.gridSize / 2) / parent.gridSize) * parent.gridSize
              + parent.gridSize / 2,
            y: round((location.y - parent.gridSize / 2) / parent.gridSize) * parent.gridSize
              + parent.gridSize / 2
          )

          let boardLocation = CGPoint(
            x: snappedViewPoint.x - size.width / 2 - parent.viewModel.totalOffset.x,
            y: snappedViewPoint.y - size.height / 2 - parent.viewModel.totalOffset.y
          )

          switch gesture.state {
            case .began:
              isPlacementActive = true
              parent.startPosition = boardLocation
              parent.currentPosition = boardLocation
              parent.viewModel.startPlacement()
              parent.viewModel.updatePlacementDragState(.valid)

            case .changed:
              parent.currentPosition = boardLocation

              // Calculate rectangle using current and start positions
              let width = abs(boardLocation.x - parent.startPosition.x)
              let height = abs(boardLocation.y - parent.startPosition.y)
              let rect = CGRect(
                x: min(parent.startPosition.x, boardLocation.x),
                y: min(parent.startPosition.y, boardLocation.y),
                width: width,
                height: height
              )

              // Validate size and position
              let isValid = width >= parent.gridSize && height >= parent.gridSize
              let wouldOverlap = parent.viewModel.wouldOverlap(rect)

              parent.viewModel.updatePlacementDragState(
                isValid && !wouldOverlap ? .valid : .invalid
              )

            case .ended, .cancelled:
              if isPlacementActive && parent.viewModel.placementDragState == .valid {
                let rect = CGRect(
                  x: min(parent.startPosition.x, boardLocation.x),
                  y: min(parent.startPosition.y, boardLocation.y),
                  width: abs(boardLocation.x - parent.startPosition.x),
                  height: abs(boardLocation.y - parent.startPosition.y)
                )
                parent.viewModel.prepareToAddItem(at: rect)
              }
              parent.viewModel.endPlacement()
              isPlacementActive = false

            default:
              break
          }
        }
      }
    }

    func gestureRecognizer(
      _ gestureRecognizer: UIGestureRecognizer,
      shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer
    ) -> Bool {
      return true
    }
  }
}

extension CGFloat {
  fileprivate func rounded(to spacing: CGFloat) -> CGFloat {
    (self / spacing).rounded() * spacing
  }
}
