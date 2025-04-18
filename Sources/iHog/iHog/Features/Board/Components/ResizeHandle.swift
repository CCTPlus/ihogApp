import SwiftUI

/// A view that displays a resize handle for board items.
/// Creates the curved L-bracket corner piece seen in iOS Control Center resize handles.
struct ResizeHandle: View {
  var body: some View {
    Path { path in
      // Start from the end of the horizontal part
      path.move(to: CGPoint(x: 0, y: 24))

      // Create the curved corner matching DOUBLE_CORNER_RADIUS
      path.addQuadCurve(
        to: CGPoint(x: 24, y: 0),
        control: CGPoint(x: 0, y: 0)
      )

      // Add thickness
      path.addLine(to: CGPoint(x: 24, y: 8))
      path.addQuadCurve(
        to: CGPoint(x: 8, y: 24),
        control: CGPoint(x: 8, y: 8)
      )
      path.closeSubpath()
    }
    .fill(.white)
    .frame(width: 24, height: 24)
  }
}

#Preview {
  ZStack(alignment: .topLeading) {
    RoundedRectangle(cornerRadius: DOUBLE_CORNER_RADIUS)
      .fill(Color.blue)
      .frame(width: 200, height: 200)

    ResizeHandle()
  }
  .frame(width: 200, height: 200)
  .padding(20)
}
