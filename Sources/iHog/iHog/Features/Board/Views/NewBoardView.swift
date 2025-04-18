import SwiftData
import SwiftUI

struct NewBoardView: View {
  @Environment(\.modelContext) private var modelContext
  @Environment(\.dismiss) private var dismiss

  let showID: UUID
  @State private var name: String = ""
  @State private var isSubmitting = false
  @State private var errorMessage: String?

  /// The repository used to create boards
  var repository: BoardRepository? = nil

  var body: some View {
    Form {
      Section {
        TextField("Name", text: $name)
      }

      if let errorMessage {
        Section {
          Text(errorMessage)
            .foregroundStyle(.red)
        }
      }
    }
    .navigationTitle("New Board")
    .navigationBarTitleDisplayMode(.inline)
    .toolbar {
      ToolbarItem(placement: .cancellationAction) {
        Button("Cancel") {
          dismiss()
        }
      }

      ToolbarItem(placement: .confirmationAction) {
        Button("Create") {
          createBoard()
        }
        .disabled(name.isEmpty || isSubmitting)
      }
    }
  }

  private func createBoard() {
    isSubmitting = true
    errorMessage = nil

    Task {
      do {
        let repo = repository ?? BoardSwiftDataRepository(modelContainer: modelContext.container)
        let createdShow = try await repo.createBoard(name: name, showID: showID)
        HogLogger
          .log(category: .board)
          .info("Created a new board with \(createdShow.name)")
        await MainActor.run {
          dismiss()
        }
      } catch {
        await MainActor.run {
          errorMessage = error.localizedDescription
          isSubmitting = false
        }
      }
    }
  }
}

#Preview {
  NewBoardView(showID: UUID())
    .modelContainer(ShowEntity.preview)
}
