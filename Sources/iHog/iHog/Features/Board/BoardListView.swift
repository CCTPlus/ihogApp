//
//  BoardListView.swift
//  iHog
//
//  Created by Jay Wilson on 4/20/25.
//

import SwiftUI

/// A view that displays a grid of boards for the current show.
/// Each board is shown as a thumbnail with its title and last modified date.
/// Supports creating new boards, selecting boards, and managing boards through context menus.
struct BoardListView: View {
  /// The view model that manages the board list state and operations
  @State var viewModel: BoardListViewModel

  /// The grid layout for board thumbnails
  private let columns = [
    GridItem(.adaptive(minimum: 160, maximum: 200), spacing: 32)
  ]

  var body: some View {
    NavigationStack {
      ScrollView {
        LazyVGrid(columns: columns, spacing: 16) {
          // Board Thumbnails
          ForEach(viewModel.boards) { board in
            boardThumbnail(for: board)
              .padding(.bottom)
          }
        }
      }
      .contentMargins(16, for: .scrollContent)
      .navigationTitle("Boards")
      .toolbar {
        ToolbarItem(placement: .topBarTrailing) {
          Button {
            Task {
              try? await viewModel.createNewBoard()
            }
          } label: {
            Image(systemName: "plus.circle")
          }
        }
      }
      .fullScreenCover(item: $viewModel.selectedBoard) { board in
        NavigationStack {
          // Placeholder until BoardView is implemented
          Text("Board: \(board.name)")
            .navigationTitle(board.name)
            .toolbar {
              ToolbarItem(placement: .topBarLeading) {
                Button {
                  viewModel.deselectBoard()
                } label: {
                  Image(systemName: "xmark.circle.fill")
                    .symbolRenderingMode(.palette)
                    .foregroundStyle(
                      Color.secondary,
                      Color.systemGray5
                    )
                }
              }
            }
        }
      }
    }
  }

  /// Creates a thumbnail view for a board
  /// - Parameter board: The board to display
  /// - Returns: A view showing the board's thumbnail, title, and last modified date
  private func boardThumbnail(for board: Board) -> some View {
    Button {
      viewModel.selectBoard(board)
    } label: {
      VStack(alignment: .leading) {
        BoardThumbnailView(board: board, scale: 0.2)

        VStack(alignment: .leading, spacing: 4) {
          Text(board.name)
            .font(.headline)
            .lineLimit(1)

          Text(board.dateLastModified, style: .date)
            .font(.caption)
            .foregroundStyle(.secondary)
        }
      }
    }
    .buttonStyle(.plain)
    .contextMenu {
      Button(role: .destructive) {
        Task {
          try? await viewModel.deleteBoard(board.id)
        }
      } label: {
        Label("Delete", systemImage: "trash")
      }

      Button {
        // TODO: Implement rename
      } label: {
        Label("Rename", systemImage: "pencil")
      }
    }
  }
}

#Preview("Empty State") {
  BoardListView(
    viewModel: BoardListViewModel(
      showID: UUID(),
      boardRepository: BoardMockRepository()
    )
  )
}

#Preview("With Boards") {
  @Previewable @State var viewModel: BoardListViewModel = BoardListViewModel(
    showID: ShowMockRepository.previewWithShows.shows[0].id,
    boardRepository: BoardMockRepository.previewWithBoards
  )
  BoardListView(
    viewModel: viewModel
  )
  .task {
    await viewModel.loadBoards()
  }
}
