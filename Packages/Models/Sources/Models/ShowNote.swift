//
//  ShowNote.swift
//  Models
//
//  Created by Jay Wilson on 1/3/25.
//

import Foundation
import SwiftData

@Model public final class ShowNote {
  public var dateCreated: Date? = Date.now
  public var dateLastModified: Date? = Date.now
  public var dateCompleted: Date? = nil
  public var body: String? = ""
  public var noteType: NoteType? = NoteType.info
  public var status: Status? = Status.noStatus

  public var show: ShowEntity?

  public init(
    dateCreated: Date = .now,
    dateLastModified: Date = .now,
    dateCompleted: Date? = nil,
    note: String? = "",
    noteType: NoteType? = .info,
    status: Status? = .noStatus,
    show: ShowEntity? = nil
  ) {
    self.dateCreated = dateCreated
    self.dateLastModified = dateLastModified
    self.dateCompleted = dateCompleted
    self.body = note
    self.noteType = noteType
    self.status = status
    self.show = show
  }
}

extension ShowNote {
  /// Type of note the user has added
  public enum NoteType: String, CaseIterable, Codable, Sendable {
    case info
    case action

    public var label: String {
      switch self {
        case .info: "Info"
        case .action: "Task"
      }
    }
  }

  /// The status of the note
  public enum Status: String, CaseIterable, Codable, Sendable {
    case completed
    case notCompleted
    case noStatus
  }
}

/// A non managed object of ShowNote
///
/// Allows for show note data to cross contexts without worry
public struct ShowNoteObject: Sendable {
  public let showID: PersistentIdentifier
  public let dateCreated: Date
  public let dateLastModified: Date
  public let note: String
  public let noteType: ShowNote.NoteType
  public let status: ShowNote.Status
  public let dateCompleted: Date?

  public init(
    showID: PersistentIdentifier,
    dateCreated: Date,
    dateLastModified: Date,
    note: String,
    noteType: ShowNote.NoteType,
    status: ShowNote.Status,
    dateCompleted: Date? = nil
  ) {
    self.showID = showID
    self.dateCreated = dateCreated
    self.dateLastModified = dateLastModified
    self.note = note
    self.noteType = noteType
    self.status = status
    self.dateCompleted = dateCompleted
  }
}
