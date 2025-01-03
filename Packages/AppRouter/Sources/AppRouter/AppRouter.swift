// The Swift Programming Language
// https://docs.swift.org/swift-book

import Foundation

@available(iOS 17.0, *)
@Observable
public final class AppRouter {
  public var selectedSheet: SheetDestination?
  public var routerDestination: RouterDestination?
  public var showID: UUID?

  public init(selectedSheet: SheetDestination? = nil, showID: UUID? = nil) {
    self.selectedSheet = selectedSheet
    if let showID {
      routerDestination = .show(showID)
    } else {
      self.showID = showID
      self.routerDestination = nil
    }
  }

  public func openSheet(_ destination: SheetDestination) {
    selectedSheet = destination
  }

  public func changeShow(to showID: UUID) {
    self.showID = showID
    self.routerDestination = .show(showID)
  }
}
