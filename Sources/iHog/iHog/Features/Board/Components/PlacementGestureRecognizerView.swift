import SwiftUI
import UIKit

/// A UIKit-based gesture recognizer for single-finger placement
struct PlacementGestureRecognizerView: UIViewRepresentable {
  let onChanged: (CGPoint) -> Void
  let onEnded: () -> Void

  func makeCoordinator() -> Coordinator {
    Coordinator(self)
  }

  func makeUIView(context: Context) -> UIView {
    let view = UIView()
    view.isUserInteractionEnabled = true
    view.isMultipleTouchEnabled = true

    let gesture = UIPanGestureRecognizer(
      target: context.coordinator,
      action: #selector(Coordinator.handlePan(_:))
    )
    gesture.minimumNumberOfTouches = 1
    gesture.maximumNumberOfTouches = 1
    gesture.delegate = context.coordinator

    view.addGestureRecognizer(gesture)
    return view
  }

  func updateUIView(_ uiView: UIView, context: Context) {}

  class Coordinator: NSObject, UIGestureRecognizerDelegate {
    let parent: PlacementGestureRecognizerView

    init(_ parent: PlacementGestureRecognizerView) {
      self.parent = parent
    }

    @objc func handlePan(_ gesture: UIPanGestureRecognizer) {
      let location = gesture.location(in: gesture.view)

      if gesture.state == .changed {
        parent.onChanged(location)
      } else if gesture.state == .ended {
        parent.onEnded()
      }
    }

    func gestureRecognizer(
      _ gestureRecognizer: UIGestureRecognizer,
      shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer
    ) -> Bool {
      return true
    }

    func gestureRecognizer(
      _ gestureRecognizer: UIGestureRecognizer,
      shouldRequireFailureOf otherGestureRecognizer: UIGestureRecognizer
    ) -> Bool {
      return false
    }

    func gestureRecognizer(
      _ gestureRecognizer: UIGestureRecognizer,
      shouldBeRequiredToFailBy otherGestureRecognizer: UIGestureRecognizer
    ) -> Bool {
      return false
    }
  }
}
