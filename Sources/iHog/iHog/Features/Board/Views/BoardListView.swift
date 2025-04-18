import AppRouter
import SwiftUI

/// A view that displays a list of boards for a show.
/// Each board is shown with a thumbnail preview and name.
struct BoardListView: View {
  /// The environment model context
  @Environment(\.modelContext) private var modelContext

  /// The AppRouter for navigation
  @Environment(AppRouter.self) private var router

  /// The ID of the show to fetch boards for
  let showID: UUID

  /// The view model managing the board list state and operations
  @State var viewModel: BoardListViewModel

  var body: some View {
    NavigationStack {
      Group {
        if viewModel.boards.isEmpty {
          ContentUnavailableView {
            Label("No Boards", systemImage: "rectangle.grid.2x2")
          } description: {
            Text("Create a new board to get started")
          } actions: {
            Button("New Board") {
              router.openSheet(.newBoard)
            }
            .buttonStyle(.borderedProminent)
          }
        } else {
          List(viewModel.boards) { board in
            Button {
              viewModel.selectedBoard = board
            } label: {
              HStack {
                BoardThumbnailView()
                Text(board.name)
                  .font(.headline)
              }
            }
            .buttonStyle(.plain)
            .swipeActions(edge: .trailing) {
              Button(role: .destructive) {
                viewModel.prepareToDelete(board)
              } label: {
                Label("Delete", systemImage: "trash")
              }

              Button {
                viewModel.prepareToRename(board)
              } label: {
                Label("Rename", systemImage: "pencil")
              }
              .tint(.blue)
            }
            .contextMenu {
              Button {
                viewModel.prepareToRename(board)
              } label: {
                Label("Rename", systemImage: "pencil")
              }

              Button(role: .destructive) {
                viewModel.prepareToDelete(board)
              } label: {
                Label("Delete", systemImage: "trash")
              }
            }
          }
        }
      }
      .navigationTitle("Boards")
      .navigationBarTitleDisplayMode(.inline)
      .toolbar {
        ToolbarItem(placement: .topBarTrailing) {
          if !viewModel.boards.isEmpty {
            Button("New Board", systemImage: "plus.circle") {
              router.openSheet(.newBoard)
            }
          } else {
            EmptyView()
          }
        }
      }
      .task {
        await viewModel.loadBoards()
      }
      .fullScreenCover(item: $viewModel.selectedBoard) { board in
        BoardView(
          viewModel: BoardViewModel(
            board: board,
            boardState: BoardState(
              isEditMode: false
            ),
            repository: viewModel.repository,
            itemRepository: viewModel.itemRepository
          ),
          showObjectRepository: viewModel.showObjectRepository
        )
      }
      .alert("Rename Board", isPresented: $viewModel.isRenameAlertPresented) {
        TextField("Board Name", text: $viewModel.newBoardName)
        Button("Cancel", role: .cancel) {
          viewModel.cancelRename()
        }
        Button("Rename") {
          Task {
            await viewModel.renameBoard()
          }
        }
      }
      .alert("Delete Board", isPresented: $viewModel.isDeleteAlertPresented) {
        Button("Cancel", role: .cancel) {
          viewModel.cancelDelete()
        }
        Button("Delete", role: .destructive) {
          Task {
            await viewModel.deleteBoard()
          }
        }
      } message: {
        if let board = viewModel.boardToDelete {
          Text("Are you sure you want to delete \"\(board.name)\"? This action cannot be undone.")
        }
      }
    }
  }
}

#Preview("With Boards") {
  BoardListView(
    showID: ShowMockRepository.previewWithShows.shows[0].id,
    viewModel: BoardListViewModel(
      showID: ShowMockRepository.previewWithShows.shows[0].id,
      repository: BoardMockRepository.previewWithBoards,
      itemRepository: BoardItemMockRepository.previewWithItems,
      showObjectRepository: ShowObjectMockRepository.preview
    )
  )
  .environment(AppRouter())
}

#Preview("Empty State") {
  BoardListView(
    showID: ShowMockRepository.previewWithShows.shows[0].id,
    viewModel: BoardListViewModel(
      showID: ShowMockRepository.previewWithShows.shows[0].id,
      repository: BoardMockRepository(),
      itemRepository: BoardItemMockRepository(items: []),
      showObjectRepository: ShowObjectMockRepository(
        objects: [],
        showID: ShowMockRepository.previewWithShows.shows.first!.id
      )
    )
  )
  .environment(AppRouter())
}
