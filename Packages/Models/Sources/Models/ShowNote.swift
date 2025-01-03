//
//  ShowNote.swift
//  Models
//
//  Created by Jay Wilson on 1/3/25.
//

import Foundation
import SwiftData

@available(iOS 17.0, *)
@Model public final class ShowNote {
  public var dateCreated: Date = Date.now
  public var dateLastModified: Date = Date.now
  public var note: String = ""
  public var noteType: NoteType = NoteType.info

  public var show: ShowEntity?

  public init(
    dateCreated: Date = Date(),
    dateLastModified: Date = Date(),
    note: String = "",
    noteType: NoteType = .info
  ) {
    self.dateCreated = dateCreated
    self.dateLastModified = dateLastModified
    self.note = note
    self.noteType = noteType
  }
}

@available(iOS 17.0, *)
extension ShowNote {
  /// Type of note the user has added
  public enum NoteType: String, CaseIterable, Codable {
    case info
    case action
  }
}
