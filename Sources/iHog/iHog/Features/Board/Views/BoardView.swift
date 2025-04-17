import SwiftUI

/// A container view that provides an infinite scrollable area for board items.
/// The view maintains a center origin coordinate system and manages multiple layers:
/// - Grid layer (back)
/// - Board Items layer (middle)
/// - Board UI layer (front)
struct BoardView: View {
  /// The view model that manages the board's state and behavior
  @Bindable var viewModel: BoardViewModel

  /// The current scroll position
  @State private var scrollOffset: CGPoint = .zero

  /// The content offset (used to reset scroll position)
  @State private var contentOffset: CGPoint = .zero

  /// The size of the scrollable area
  private let scrollAreaSize: CGFloat = 2000

  var body: some View {
    NavigationStack {
      GeometryReader { geometry in
        ScrollViewReader { proxy in
          ScrollView([.horizontal, .vertical], showsIndicators: false) {
            ZStack {
              // Grid layer (back)
              if viewModel.boardState.isGridVisible {
                GridView(
                  size: geometry.size,
                  zoomLevel: viewModel.boardState.zoomLevel,
                  scrollOffset: scrollOffset,
                  contentOffset: contentOffset
                )
              }
            }
            .frame(width: scrollAreaSize, height: scrollAreaSize)
            .id("center")
            .background(
              GeometryReader { proxy in
                Color.clear.preference(
                  key: ScrollOffsetPreferenceKey.self,
                  value: proxy.frame(in: .named("scroll")).origin
                )
              }
            )
          }
          .coordinateSpace(name: "scroll")
          .onAppear {
            // Start centered
            withAnimation(.none) {
              proxy.scrollTo("center", anchor: .center)
            }
          }
          .onPreferenceChange(ScrollOffsetPreferenceKey.self) { value in
            // Update scroll offset
            let oldOffset = scrollOffset
            scrollOffset = value

            // Calculate the change in scroll position
            let dx = value.x - oldOffset.x
            let dy = value.y - oldOffset.y

            // Update content offset
            contentOffset = CGPoint(
              x: contentOffset.x - dx,
              y: contentOffset.y - dy
            )
          }
        }
      }
      .toolbarRole(.navigationStack)
      .toolbarTitleDisplayMode(.inline)
      .toolbarBackground(.hidden, for: .navigationBar)
      .toolbar {
        ToolbarItem(placement: .navigationBarLeading) {
          Button(action: {}) {
            Image(systemName: "xmark")
          }
        }

        ToolbarItem(placement: .principal) {
          Text(viewModel.board.name)
            .font(.headline)
        }

        ToolbarItemGroup(placement: .navigationBarTrailing) {
          Button(action: {}) {
            Image(systemName: "arrow.uturn.backward")
          }

          Button(action: {}) {
            Image(systemName: "arrow.uturn.forward")
          }

          Button(action: viewModel.toggleEditMode) {
            Image(systemName: viewModel.boardState.isEditMode ? "pencil" : "play.fill")
          }
        }
      }
    }
  }
}

/// A preference key to track scroll position
private struct ScrollOffsetPreferenceKey: PreferenceKey {
  static var defaultValue: CGPoint = .zero

  static func reduce(value: inout CGPoint, nextValue: () -> CGPoint) {
    value = nextValue()
  }
}

#Preview {
  BoardView(
    viewModel: BoardViewModel(
      board: BoardMockRepository.previewWithBoards.boards[0],
      boardState: BoardState(isEditMode: true),
      repository: BoardMockRepository.previewWithBoards
    )
  )
}
