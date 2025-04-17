import SwiftUI

/// A view that displays a grid of dots for the board.
/// The grid is centered at (0,0) and extends infinitely in all directions.
struct GridView: View {
  /// The size of the visible area
  let size: CGSize

  /// The current zoom level
  let zoomLevel: CGFloat

  /// The current scroll position
  let scrollOffset: CGPoint

  /// The content offset (used for infinite scrolling)
  let contentOffset: CGPoint

  /// The spacing between grid dots at zoom level 1.0
  private let baseSpacing: CGFloat = 44.0

  var body: some View {
    Canvas { context, size in
      // Calculate the actual spacing based on zoom level
      let spacing = baseSpacing * zoomLevel

      // Calculate the total offset from (0,0)
      let totalOffsetX = scrollOffset.x + contentOffset.x
      let totalOffsetY = scrollOffset.y + contentOffset.y

      // Calculate the visible grid bounds
      let minX = (totalOffsetX - spacing * 10).rounded(to: spacing)
      let maxX = (totalOffsetX + size.width + spacing * 10).rounded(to: spacing)
      let minY = (totalOffsetY - spacing * 10).rounded(to: spacing)
      let maxY = (totalOffsetY + size.height + spacing * 10).rounded(to: spacing)

      // Calculate number of dots needed
      let horizontalDots = Int((maxX - minX) / spacing)
      let verticalDots = Int((maxY - minY) / spacing)

      // Draw dots
      for x in 0...horizontalDots {
        for y in 0...verticalDots {
          let dotX = minX + CGFloat(x) * spacing - totalOffsetX
          let dotY = minY + CGFloat(y) * spacing - totalOffsetY

          context.fill(
            Circle()
              .path(
                in: CGRect(
                  x: dotX - 1,
                  y: dotY - 1,
                  width: 2,
                  height: 2
                )
              ),
            with: .color(.gray.opacity(0.5))
          )
        }
      }
    }
  }
}

extension CGFloat {
  fileprivate func rounded(to spacing: CGFloat) -> CGFloat {
    (self / spacing).rounded() * spacing
  }
}

#Preview {
  ZStack {
    Color.white
    GridView(
      size: CGSize(width: 1000, height: 1000),
      zoomLevel: 1.0,
      scrollOffset: CGPoint(x: 0, y: 0),
      contentOffset: CGPoint(x: 0, y: 0)
    )
  }
}
