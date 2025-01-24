//
//  ShowNotesView.swift
//  iHog
//
//  Created by Jay Wilson on 1/3/25.
//

import Models
import SwiftData
import SwiftUI

/// View that shows all the notes a user has
@MainActor
struct ShowNotesView: View {
  @Environment(\.modelContext) var modelContext

  let showID: UUID

  @Query private var shows: [ShowEntity]
  @Query private var allShowNotes: [ShowNote]

  @State private var showNewNoteField: Bool = false

  init(showID: UUID) {
    self.showID = showID
    let predicate = #Predicate<ShowEntity> { show in
      show.id == showID
    }
    _shows = Query(filter: predicate, animation: .default)
  }

  // Return the found show notes
  var notes: [ShowNote] {
    //    print("Accessing notes")
    //    if let show = shows.first {
    //      print("Found show: \(show.id)")
    //      let notes = show.notes ?? []
    //      print("Found \(notes.count) notes")
    //      return notes
    //    }
    //    print("No show found")
    return []
  }

  var body: some View {
    Group {
      if allShowNotes.isEmpty && showNewNoteField == false {
        ContentUnavailableView {
          Label("No Notes", systemImage: "pencil.and.list.clipboard")
        } description: {
          Text("You don't have any notes yet.\nAdd a new note.")
        } actions: {
          Button {
            showNewNoteField.toggle()
          } label: {
            Text("Add Note")
          }
          .buttonStyle(.borderedProminent)
          .controlSize(.regular)
        }
        .background(Color.systemGroupedBackground)
      } else {
        List {
          if showNewNoteField {
            NewNoteView(isPresented: $showNewNoteField, showID: shows.first!.persistentModelID)
              .environment(\.modelContext, modelContext)
          }
          ForEach(allShowNotes) { note in
            HStack(spacing: 16) {
              Text(note.body ?? "No note text")
            }
          }
        }
      }
    }
    .navigationTitle("Notes")
    .toolbar {
      ToolbarItem(placement: .topBarTrailing) {
        Menu("Filter", systemImage: "line.3.horizontal.decrease.circle") {
          Text("Filter")
        }

      }
    }
  }
}

@available(iOS 18.0, *)
#Preview(traits: .modifier(ShowEntityPreviewModifier())) {
  @Previewable @Query(sort: \ShowEntity.dateCreated) var shows: [ShowEntity]

  NavigationStack {
    if let showID = shows.first?.id {
      ShowNotesView(showID: showID)
        .task {
          print(showID)
        }
    } else {
      Text("NO SHOW FOUND WITH AN ID")
    }
  }
  .modelContainer(ShowEntity.previewWithNotes)
}

@available(iOS 18.0, *)
#Preview("Debug for preview", traits: .modifier(ShowEntityPreviewModifier())) {
  @Previewable @Query(sort: \ShowEntity.dateCreated) var shows: [ShowEntity]

  NavigationStack {
    List {
      ForEach(shows) { show in
        HStack {
          Text(show.name ?? "NO NAME")
          Text("Notes: \(show.notes?.count ?? 0)")
        }
      }
    }
  }
  .modelContainer(ShowEntity.previewWithNotes)
}
