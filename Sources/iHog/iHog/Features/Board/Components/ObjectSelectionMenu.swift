import SwiftUI

/// A view that presents a menu for selecting show objects to place on the board.
/// This menu includes search functionality, type filtering, and object preview.
struct ObjectSelectionMenu: View {
  /// The repository used to fetch show objects
  let repository: ShowObjectRepository

  /// The ID of the show to fetch objects from
  let showID: UUID

  /// The currently selected object type filter
  @State private var selectedTypes: [ShowObjectType] = []

  /// The search text entered by the user
  @State private var searchText = ""

  /// The currently selected show object
  @State private var selectedObject: ShowObject?

  @State private var filters = ShowObjectType.boardObjects
  /// The action to perform when an object is selected
  let onSelect: (ShowObject) -> Void

  /// The environment dismiss action
  @Environment(\.dismiss) private var dismiss

  /// The list of objects to display, filtered by type and search text
  @State private var objects: [ShowObject] = []

  var body: some View {
    NavigationStack {
      List {
        Section {
          if objects.isEmpty {
            Text("No objects found")
              .foregroundColor(.secondary)
          } else {
            ForEach(objects) { obj in
              Button {
                onSelect(obj)
                dismiss()
              } label: {
                HStack {
                  Text(obj.getName())
                  Spacer()
                  Text("\(obj.getShortType()) \(obj.getObjNumber())")
                    .monospaced()
                }
              }
              .tint(OBJ_COLORS[obj.getColor()])
            }
          }
        }
      }
      .navigationTitle("Select Object")
      .navigationBarTitleDisplayMode(.inline)
      .searchable(
        text: $searchText,
        tokens: $selectedTypes,
        suggestedTokens: $filters,
        prompt: "Search for an object"
      ) { token in
        Text(token.rawValue.capitalized)
      }
      .toolbar {
        ToolbarItem(placement: .cancellationAction) {
          Button("Cancel") {
            dismiss()
          }
        }
      }
      .task {
        await loadObjects()
      }
      .onChange(of: selectedTypes) {
        Task {
          await loadObjects()
        }
      }
      .onChange(of: searchText) {
        Task {
          await loadObjects()
        }
      }
    }
  }

  private func loadObjects() async {
    do {
      var filteredObjects: [ShowObject] = []

      if selectedTypes.isEmpty {
        filteredObjects = try await repository.getAllObjects(for: showID)
      } else {
        for type in selectedTypes {
          let objects = try await repository.getAllObjects(from: showID, of: type)
          filteredObjects.append(contentsOf: objects)
        }
      }

      // Apply search filter
      if !searchText.isEmpty {
        objects = filteredObjects.filter { object in
          object.getName().localizedCaseInsensitiveContains(searchText)
        }
      } else {
        objects = filteredObjects
      }
    } catch {
      HogLogger.log(category: .board).error("Error loading objects: \(error.localizedDescription)")
    }
  }
}

#Preview("Empty State") {
  ObjectSelectionMenu(
    repository: ShowObjectMockRepository.preview,
    showID: ShowMockRepository.previewWithShows.shows[0].id,
    onSelect: { _ in }
  )
}

#Preview("With Objects") {
  ObjectSelectionMenu(
    repository: ShowObjectMockRepository.preview,
    showID: ShowMockRepository.previewWithShows.shows[0].id,
    onSelect: { _ in }
  )
}

#Preview("Filtered") {
  ObjectSelectionMenu(
    repository: ShowObjectMockRepository.preview,
    showID: ShowMockRepository.previewWithShows.shows[0].id,
    onSelect: { _ in }
  )
  .searchable(text: .constant("Group"))
}

#Preview("Search Active") {
  ObjectSelectionMenu(
    repository: ShowObjectMockRepository.preview,
    showID: ShowMockRepository.previewWithShows.shows[0].id,
    onSelect: { _ in }
  )
  .searchable(text: .constant("Scene"))
}
