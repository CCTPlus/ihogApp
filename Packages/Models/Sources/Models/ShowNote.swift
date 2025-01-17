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
  public var note: String? = ""
  public var noteType: NoteType? = NoteType.info
  public var status: Status? = Status.noStatus

  @Relationship(inverse: \ShowEntity.notes) public var show: ShowEntity?

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
    self.note = note
    self.noteType = noteType
    self.status = status
    self.show = show
  }
}

extension ShowNote {
  /// Type of note the user has added
  public enum NoteType: String, CaseIterable, Codable {
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
  public enum Status: String, CaseIterable, Codable {
    case completed
    case notCompleted
    case noStatus
  }
}
