//
//  BoardView.swift
//  iHog
//
//  Created by Jay Wilson on 4/20/25.
//

import SwiftUI

/// A view that displays an infinite canvas with a grid system.
/// Supports panning, zooming, and mode switching between edit and play modes.
struct BoardView: View {
  /// The view model that manages the board state
  @State var viewModel: BoardViewModel
  @State private var dragStart: CGPoint = .zero

  var body: some View {
    GeometryReader { geometry in
      ZStack {
        if viewModel.mode == .edit {
          BoardGridView(panOffset: viewModel.panOffset)
        }

        // Board items will go here
      }
      .gesture(
        SimultaneousGesture(
          // Pan gesture
          DragGesture()
            .onChanged { value in
              Task {
                try? await viewModel.updatePanOffset(dragStart + value.translation)
              }
            }
            .onEnded { _ in
              dragStart = viewModel.panOffset
            },
          // Zoom gesture
          MagnificationGesture()
            .onChanged { value in
              Task {
                try? await viewModel.updateZoomScale(value)
              }
            }
        )
      )
    }
    .toolbar {
      ToolbarItem(placement: .topBarTrailing) {
        Button {
          Task {
            if viewModel.mode == .edit {
              try? await viewModel.enterPlayMode()
            } else {
              try? await viewModel.enterEditMode()
            }
          }
        } label: {
          Image(systemName: viewModel.mode == .play ? "play.fill" : "pencil")
        }
      }
    }
  }
}

extension CGPoint {
  static func + (lhs: CGPoint, rhs: CGSize) -> CGPoint {
    CGPoint(x: lhs.x + rhs.width, y: lhs.y + rhs.height)
  }
}

#Preview("Edit Mode") {
  @Previewable @State var viewModel = BoardViewModel(
    board: Board.preview,
    boardRepository: BoardMockRepository(),
    boardItemRepository: BoardItemMockRepository()
  )
  NavigationStack {
    BoardView(
      viewModel: viewModel
    )
    .navigationTitle("Board")
  }
}

#Preview("Play Mode") {
  @Previewable @State var viewModel = BoardViewModel(
    board: Board.preview,
    mode: .play,
    boardRepository: BoardMockRepository(),
    boardItemRepository: BoardItemMockRepository()
  )
  NavigationStack {
    BoardView(
      viewModel: viewModel
    )
    .navigationTitle("Board")
  }
}
