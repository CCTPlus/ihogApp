//
//  NewNoteView.swift
//  iHog
//
//  Created by Jay Wilson on 1/3/25.
//

import Models
import SwiftData
import SwiftUI

struct NewNoteView: View {
  @Environment(\.modelContext) var modelContext

  enum Field: Hashable {
    case note
  }

  @State private var note: String = ""
  @State private var noteType: ShowNote.NoteType = .info

  @FocusState private var focusField: Field?

  @Binding var isPresented: Bool

  var showID: PersistentIdentifier

  var body: some View {
    HStack(alignment: .firstTextBaseline) {
      Image(systemName: noteType == .action ? "circle" : "square")
        .font(.headline)
        .foregroundStyle(noteType == .action ? .secondary : .tertiary)
        .symbolVariant(noteType == .action ? .none : .fill)
      VStack {
        TextField("Show note", text: $note)
          .font(.headline)
          .focused($focusField, equals: .note)
        HStack(spacing: 16) {
          Button(noteType.label) {
            withAnimation {
              switch noteType {
                case .action: noteType = .info
                case .info: noteType = .action
              }
            }
          }
          .foregroundStyle(.tint)
          .buttonStyle(.plain)
          Spacer()
          Button("Cancel") {
            isPresented = false
          }
          .buttonStyle(.plain)
          .foregroundStyle(.red)
          Button("Save") {
            saveNote()
          }
          .buttonStyle(.borderedProminent)
          .buttonStyle(.plain)
          .tint(.green)
          .disabled(note.isEmpty)
        }
      }
      .task {
        // As soon as this shows make it in focus
        focusField = .note
      }
    }
  }
}

@available(iOS 18.0, *)
#Preview(traits: .modifier(ShowEntityPreviewModifier())) {
  @Previewable @Query(sort: \ShowEntity.dateCreated) var shows: [ShowEntity]

  NavigationStack {
    List {
      NewNoteView(isPresented: .constant(true), showID: shows.first!.persistentModelID)
    }
    .navigationTitle("Notes")
  }
  .modelContainer(ShowEntity.previewWithNotes)
}

extension NewNoteView {
  func saveNote() {
    // Make sure show exists for the ID
    guard let showEntity: ShowEntity = modelContext.registeredModel(for: showID) else {
      HogLogger.log(category: .swiftData)
        .error("🚨 Cannot find show for the showID \(showID.id.hashValue)")
      return
    }

    let body = note

    let newNote = ShowNoteObject(
      showID: showEntity.persistentModelID,
      dateCreated: .now,
      dateLastModified: .now,
      note: body,
      noteType: noteType,
      status: noteType == .action ? .notCompleted : .noStatus
    )

    let container = modelContext.container

    Task.detached(priority: .userInitiated) {
      let manager = NoteManager(modelContainer: container)
      await manager.addNote(newNote: newNote)
    }

    isPresented = false
  }
}
