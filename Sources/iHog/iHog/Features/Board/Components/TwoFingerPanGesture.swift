import SwiftUI
import UIKit

/// A SwiftUI wrapper for a two-finger pan gesture recognizer
struct TwoFingerPanGesture: UIViewRepresentable {
  let onChanged: (CGPoint) -> Void
  let onEnded: (CGPoint) -> Void
  let sensitivity: CGFloat

  init(
    sensitivity: CGFloat = 1.0,
    onChanged: @escaping (CGPoint) -> Void,
    onEnded: @escaping (CGPoint) -> Void
  ) {
    self.sensitivity = sensitivity
    self.onChanged = onChanged
    self.onEnded = onEnded
  }

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
    gesture.minimumNumberOfTouches = 2
    gesture.maximumNumberOfTouches = 2
    gesture.delegate = context.coordinator

    view.addGestureRecognizer(gesture)
    return view
  }

  func updateUIView(_ uiView: UIView, context: Context) {}

  class Coordinator: NSObject, UIGestureRecognizerDelegate {
    let parent: TwoFingerPanGesture

    init(_ parent: TwoFingerPanGesture) {
      self.parent = parent
    }

    @objc func handlePan(_ gesture: UIPanGestureRecognizer) {
      let translation = gesture.translation(in: gesture.view)
      let scaledTranslation = CGPoint(
        x: translation.x * parent.sensitivity,
        y: translation.y * parent.sensitivity
      )

      if gesture.state == .changed {
        parent.onChanged(scaledTranslation)
        gesture.setTranslation(.zero, in: gesture.view)
      } else if gesture.state == .ended {
        parent.onEnded(scaledTranslation)
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
