// Show.swift
//
//
//
// Follow Jay on mastodon @heyjay@iosdev.space
//               threads  @heyjaywilson
//               github   @heyjaywilson
//               website  cctplus.dev

import Foundation

public struct Show: Equatable, Identifiable {
  public let id: UUID
  public var name: String

  public init(id: UUID, name: String) {
    self.id = id
    self.name = name
  }
}

extension Show {
  public static let mock = Show(id: UUID(), name: "The Eras Tour")
}
