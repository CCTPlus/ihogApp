//
//  NewNoteView.swift
//  iHog
//
//  Created by Jay Wilson on 1/3/25.
//

import Models
import SwiftData
import SwiftUI

@MainActor
struct NewNoteView: View {
  @Environment(\.modelContext) var modelContext

  enum Field: Hashable {
    case note
  }

  @State private var note: String = ""
  @State private var noteType: ShowNote.NoteType = .info

  @FocusState private var focusField: Field?

  @Binding var isPresented: Bool

  var show: ShowEntity

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
      NewNoteView(isPresented: .constant(true), show: shows.first!)
    }
    .navigationTitle("Notes")
  }
  .modelContainer(ShowEntity.previewWithNotes)
}

extension NewNoteView {
  @MainActor
  func saveNote() {
    let newNote = ShowNote(
      note: note,
      noteType: noteType,
      status: noteType == .action ? .notCompleted : .noStatus
    )
    modelContext.insert(newNote)
    show.notes?.append(newNote)
    do {
      try modelContext.save()
      isPresented = false
    } catch {
      Analytics.shared.logError(with: error, for: .show, level: .critical)
    }
    isPresented = false
  }
}
