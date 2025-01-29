//
//  NoteManager.swift
//  iHog
//
//  Created by Jay Wilson on 1/24/25.
//

import Models
import SwiftData

/// Responsible for all writing of Notes to Swift Data
@ModelActor
actor NoteManager {

  func addNote(newNote: ShowNoteObject) {
    //    let newShowNote = ShowNote(
    //      dateCreated: newNote.dateCreated,
    //      dateLastModified: newNote.dateLastModified,
    //      dateCompleted: newNote.dateCompleted,
    //      note: newNote.note,
    //      noteType: newNote.noteType,
    //      status: newNote.status,
    //      show: nil
    //    )

    guard let show = self[newNote.showID, as: ShowEntity.self] else {
      HogLogger.log(category: .swiftData).error("🚨 Show not found for given id)")
      return
    }

    // This causes a crash... not sure why
    HogLogger.log(category: .swiftData).debug("\(show.name)")

    //    do {
    //      try modelContext.save()
    //      modelContext.insert(newShowNote)
    //      try modelContext.save()
    //    } catch {
    //      HogLogger.log(category: .swiftData).error("🚨 Could not save \(error, privacy: .public)")
    //    }
  }
}
